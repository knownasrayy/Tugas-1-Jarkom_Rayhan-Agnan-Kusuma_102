# Tugas 1 Jarkom: Subnetting VLSM, CIDR, & Routing

Ini adalah repositori untuk pengerjaan Tugas 1 mata kuliah Komunikasi Data dan Jaringan Komputer.

Tugas ini mencakup perancangan topologi jaringan, perhitungan subnetting menggunakan VLSM, dan implementasi routing statis (termasuk agregasi CIDR) pada Cisco Packet Tracer.

---

## Deskripsi Tugas

Yayasan Pendidikan ARA akan membangun jaringan untuk beberapa unit kerja. Sebagian unit berada di kantor pusat, sedangkan Bidang Pengawas Sekolah berada di kantor cabang.

### Kebutuhan Host

#### Kantor Pusat
| Ruang | Jumlah Host Aktif |
| :--- | :--- |
| Sekretariat | 380 host |
| Bidang Kurikulum | 220 host |
| Bidang Guru & Tendik | 95 host |
| Bidang Sarana Prasarana | 45 host |
| Server & Admin | 6 host |

#### Kantor Cabang
| Ruang | Jumlah Host Aktif |
| :--- | :--- |
| Bidang Pengawas Sekolah | 18 host |

---

## Analisis & Perhitungan Jaringan

### 1. Penentuan Base Network Unik

Tugas ini menggunakan *base network* unik berdasarkan NRP `10.(NRP mod 256).0.0`.

* **NRP:** `5027241102`
* **Perhitungan mod 256:**
    * `5027241102 / 256 = 19637660.55...`
    * Bagian bulat: `19637660`
    * `19637660 * 256 = 5027240960`
    * Hasil mod: `5027241102 - 5027240960 = 142`
* **Base Network:** `10.142.0.0`

### 2. Tabel Perhitungan VLSM

Jaringan diurutkan dari kebutuhan host terbesar ke terkecil untuk mengalokasikan IP dari *base network* `10.142.0.0`.

| Kebutuhan Ruang | Jml Host | Ukuran Blok (2^n) | Prefix (/) | Subnet Mask | Network Address | Gateway (IP Router) | Range Host (Usable) | Broadcast Address |
| :--- | :---: | :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| **Sekretariat** | 380 | 512 (2^9) | /23 | `255.255.254.0` | **`10.142.0.0`** | `10.142.0.1` | `10.142.0.1` - `10.142.1.254` | `10.142.1.255` |
| **Bid. Kurikulum** | 220 | 256 (2^8) | /24 | `255.255.255.0` | **`10.142.2.0`** | `10.142.2.1` | `10.142.2.1` - `10.142.2.254` | `10.142.2.255` |
| **Bid. Guru & Tendik**| 95 | 128 (2^7) | /25 | `255.255.255.128`| **`10.142.3.0`** | `10.142.3.1` | `10.142.3.1` - `10.142.3.126` | `10.142.3.127` |
| **Bid. Sarpras** | 45 | 64 (2^6) | /26 | `255.255.255.192`| **`10.142.3.128`**| `10.142.3.129`| `10.142.3.129` - `10.142.3.190` | `10.142.3.191` |
| **Bid. Pengawas** | 18 | 32 (2^5) | /27 | `255.255.255.224`| **`10.142.3.192`**| `10.142.3.193`| `10.142.3.193` - `10.142.3.222` | `10.142.3.223` |
| **Server & Admin** | 6 | 8 (2^3) | /29 | `255.255.255.248`| **`10.142.3.224`**| `10.142.3.225`| `10.142.3.225` - `10.142.3.230` | `10.142.3.231` |
| **Link WAN** | 2 | 4 (2^2) | /30 | `255.255.255.252`| **`10.142.3.232`**| (N/A) | `10.142.3.233` - `10.142.3.234` | `10.142.3.235` |

### 3. Perhitungan CIDR (Supernetting)

Untuk memenuhi *requirement* tugas, *static route* di `Router_Cabang` di-agregasi (supernetting) untuk merangkum semua 5 jaringan LAN di `Router_Pusat`.

* **Jaringan di Pusat yang akan dirangkum:**
    * `10.142.0.0 /23` (Sekretariat)
    * `10.142.2.0 /24` (Kurikulum)
    * `10.142.3.0 /25` (Guru & Tendik)
    * `10.142.3.128 /26` (Sarpras)
    * `10.142.3.224 /29` (Server & Admin)
* **Rute Agregasi (Supernet):** **`10.142.0.0 /22`**
* **Penjelasan:** Rute `10.142.0.0 /22` (Subnet Mask `255.255.252.0`) mencakup *range* alamat `10.142.0.0` hingga `10.142.3.255`, yang secara efisien mencakup semua 5 jaringan di atas.

---

## Implementasi Topologi & Konfigurasi

### 1. Desain Topologi

Topologi dirancang dengan 2 router untuk memisahkan **Kantor Pusat** dan **Kantor Cabang** sesuai skenario, dihubungkan oleh satu **Link WAN**.

* **`Router_Pusat` (Model 2911):** Bertindak sebagai *gateway* untuk 5 jaringan LAN (Sekretariat, Kurikulum, Guru, Sarpras, Server).
* **`Router_Cabang` (Model 1941):** Bertindak sebagai *gateway* untuk 1 jaringan LAN (Bidang Pengawas).
* **Link WAN:** Kedua router terhubung melalui link Serial (WAN) yang menggunakan subnet `10.142.3.232 /30`.

### 2. Poin Konfigurasi Penting

#### Konfigurasi Gateway (SVI)
Karena `Router_Pusat` menggunakan module `HWIC-4ESW` (yang merupakan module switch Layer 2), IP *gateway* untuk jaringan **Sarpras** dan **Server** tidak bisa dipasang di port fisik (`FastEthernet`). Solusinya adalah menggunakan **SVI (Interface VLAN)**:

* **Jaringan Sarpras:**
    * Gateway (SVI): `interface Vlan40` diberi IP `10.142.3.129`.
    * Port Fisik Router: `interface FastEthernet0/3/0` dimasukkan ke VLAN 40 (`switchport access vlan 40`).
    * Switch Eksternal: Port yang terhubung ke router dan PC juga dikonfigurasi ke `VLAN 40`.
* **Jaringan Server & Admin:**
    * Gateway (SVI): `interface Vlan50` diberi IP `10.142.3.225`.
    * Port Fisik Router: `interface FastEthernet0/3/1` dimasukkan ke VLAN 50.
    * Switch Eksternal: Dikonfigurasi untuk `VLAN 50`.

#### Konfigurasi Static Routing
Untuk menghubungkan kedua lokasi, *static route* digunakan:

* **Di `Router_Pusat`:** (Rute spesifik ke jaringan Cabang)
    ```
    ip route 10.142.3.192 255.255.255.224 10.142.3.234
    ```
* **Di `Router_Cabang`:** (Rute agregasi/CIDR ke semua jaringan Pusat)
    ```
    ip route 10.142.0.0 255.255.252.0 10.142.3.233
    ```

---

## 🏁 Hasil Akhir

Seluruh konfigurasi telah diterapkan pada file `.pkt` dalam repositori ini. Semua perangkat di 6 jaringan LAN yang berbeda (termasuk antar-cabang) dapat saling terhubung, dibuktikan dengan tes `ping` yang sukses.
