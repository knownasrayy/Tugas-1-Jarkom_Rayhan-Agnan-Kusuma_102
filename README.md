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

## Analisis & Perhitungan Jaringan (Sesuai Laporan)

Berikut adalah rincian perhitungan yang diminta untuk laporan.

### 1. Penentuan Base Network Unik

Tugas ini menggunakan *base network* unik berdasarkan NRP `10.(NRP mod 256).0.0`.

* **NRP:** `5027241102`
* **Perhitungan mod 256:**
    * `5027241102 / 256 = 19637660.55...`
    * Bagian bulat: `19637660`
    * `19637660 * 256 = 5027240960`
    * Hasil mod: `5027241102 - 5027240960 = 142`
* **Base Network:** `10.142.0.0`

### 2. Tabel Hasil VLSM

Jaringan diurutkan dari kebutuhan host terbesar ke terkecil untuk mengalokasikan IP dari *base network* `10.142.0.0`. Kolom "Gateway" adalah IP yang dialokasikan untuk interface router.

| Kebutuhan Ruang | Jml Host | Ukuran Blok (2^n) | Prefix (/) | Subnet Mask | Network Address | Gateway (IP Router) | Range Host (Usable) | Broadcast Address |
| :--- | :---: | :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| **Sekretariat** | 380 | 512 (2^9) | /23 | `255.255.254.0` | **`10.142.0.0`** | `10.142.0.1` | `10.142.0.1` - `10.142.1.254` | `10.142.1.255` |
| **Bid. Kurikulum** | 220 | 256 (2^8) | /24 | `255.255.255.0` | **`10.142.2.0`** | `10.142.2.1` | `10.142.2.1` - `10.142.2.254` | `10.142.2.255` |
| **Bid. Guru & Tendik**| 95 | 128 (2^7) | /25 | `255.255.255.128`| **`10.142.3.0`** | `10.142.3.1` | `10.142.3.1` - `10.142.3.126` | `10.142.3.127` |
| **Bid. Sarpras** | 45 | 64 (2^6) | /26 | `255.255.255.192`| **`10.142.3.128`**| `10.142.3.129`| `10.142.3.129` - `10.142.3.190` | `10.142.3.191` |
| **Bid. Pengawas** | 18 | 32 (2^5) | /27 | `255.255.255.224`| **`10.142.3.192`**| `10.142.3.193`| `10.142.3.193` - `10.142.3.222` | `10.142.3.223` |
| **Server & Admin** | 6 | 8 (2^3) | /29 | `255.255.255.248`| **`10.142.3.224`**| `10.142.3.225`| `10.142.3.225` - `10.142.3.230` | `10.142.3.231` |
| **Link WAN** | 2 | 4 (2^2) | /30 | `255.255.255.252`| **`10.142.3.232`**| (N/A) | `10.142.3.233` - `10.142.3.234` | `10.142.3.235` |

### 3. Tabel Hasil CIDR (Agregasi Rute)

Tabel ini menunjukkan satu rute agregat (supernet) yang digunakan di `Router_Cabang` untuk mewakili *semua* jaringan di Kantor Pusat.

| Deskripsi | Network (Agregat) | Subnet Mask | Prefix (/) | Range Host (Usable) | Broadcast | Gateway (Next-Hop) |
| :--- | :--- | :--- | :---: | :--- | :--- | :--- |
| Rangkuman 5 LAN di Kantor Pusat | **`10.142.0.0`** | **`255.255.252.0`** | **/22** | `10.142.0.1` - `10.142.3.254` | `10.142.3.255` | **`10.142.3.233`** |

**Penjelasan:** "Gateway (Next-Hop)" adalah IP `Router_Pusat` dari sudut pandang `Router_Cabang`. Perintah `ip route 10.142.0.0 255.255.252.0 10.142.3.233` digunakan di `Router_Cabang` untuk menerapkan rute CIDR ini.

### 4. Tabel / Visualisasi Supernetting dari CIDR

Tabel ini memvisualisasikan mengapa rute agregasi `10.142.0.0 /22` adalah pilihan yang benar.

| Jaringan LAN di Pusat | Network Address | Prefix | Range Alamat | Status |
| :--- | :--- | :---: | :--- | :--- |
| Sekretariat | `10.142.0.0` | /23 | `10.142.0.0` - `10.142.1.255` | **Tercakup** |
| Kurikulum | `10.142.2.0` | /24 | `10.142.2.0` - `10.142.2.255` | **Tercakup** |
| Guru & Tendik | `10.142.3.0` | /25 | `10.142.3.0` - `10.142.3.127` | **Tercakup** |
| Sarpras | `10.142.3.128` | /26 | `10.142.3.128` - `10.142.3.191` | **Tercakup** |
| Server & Admin | `10.142.3.224` | /29 | `10.142.3.224` - `10.142.3.231` | **Tercakup** |
| **Rute Agregasi (Supernet)** | **`10.142.0.0`** | **/22** | **`10.142.0.0` - `10.142.3.255`** | **Mencakup Semua** |

**Penjelasan:** Rute agregasi `10.142.0.0 /22` (mask `255.255.252.0`) memiliki *range* dari `10.142.0.0` hingga `10.142.3.255`. Seperti yang terlihat di tabel, *range* ini **sepenuhnya mencakup** semua 5 jaringan LAN yang ada di Kantor Pusat.

---

## Implementasi & Langkah Konfigurasi

Desain topologi menggunakan 2 router (Pusat & Cabang) untuk memenuhi skenario soal dan mendemonstrasikan routing CIDR.

### 1. Persiapan Perangkat Keras (Router)
* **`Router_Pusat` (2911):** Module ditambahkan (router dalam keadaan mati):
    * `HWIC-4ESW` (Untuk 4 port switch, dipakai untuk LAN Sarpras & Server)
    * `HWIC-2T` (Untuk 2 port Serial, dipakai untuk Link WAN)
* **`Router_Cabang` (1941):** Module ditambahkan:
    * `HWIC-2T` (Untuk 2 port Serial, dipakai untuk Link WAN)

### 2. Konfigurasi `Router_Pusat`
Konfigurasi gateway dilakukan untuk 5 LAN dan 1 WAN.

* **Gateway LAN (Routed Port):** IP address dipasang langsung di interface fisik:
    * `interface GigabitEthernet0/0` (Sekretariat): `ip address 10.142.0.1 255.255.254.0`
    * `interface GigabitEthernet0/1` (Kurikulum): `ip address 10.142.2.1 255.255.255.0`
    * `interface GigabitEthernet0/2` (Guru & Tendik): `ip address 10.142.3.1 255.255.255.128`
* **Gateway LAN (SVI):** Karena `HWIC-4ESW` adalah module switch, gateway dibuat menggunakan **SVI (Interface VLAN)**:
    * `interface Vlan40` (Sarpras): `ip address 10.142.3.129 255.255.255.192`
    * `interface FastEthernet0/3/0` (Port fisik) dimasukkan ke VLAN: `switchport access vlan 40`
    * `interface Vlan50` (Server): `ip address 10.142.3.225 255.255.255.248`
    * `interface FastEthernet0/3/1` (Port fisik) dimasukkan ke VLAN: `switchport access vlan 50`
* **Gateway WAN (DCE):**
    * `interface Serial0/2/0`: `ip address 10.142.3.233 255.255.255.252`
    * Sisi DCE (pemberi sinyal jam): `clock rate 64000`

### 3. Konfigurasi `Router_Cabang`
* **Gateway LAN:**
    * `interface GigabitEthernet0/0` (Pengawas): `ip address 10.142.3.193 255.255.255.224`
* **Gateway WAN (DTE):**
    * `interface Serial0/0/0`: `ip address 10.142.3.234 255.255.255.252`
    * Sisi DTE (penerima sinyal jam): **`no clock rate`** (Perintah ini penting untuk menghapus `clock rate` default agar link tidak konflik).

### 4. Konfigurasi Static Routing (CIDR)
Routing statis diperlukan agar kedua router dapat saling bertukar informasi.

* **Di `Router_Pusat`:** (Rute spesifik ke jaringan Cabang)
    ```
    ip route 10.142.3.192 255.255.255.224 10.142.3.234
    ```
* **Di `Router_Cabang`:** (Rute agregasi/CIDR ke semua jaringan Pusat)
    Rute ini merangkum 5 jaringan di Pusat menjadi 1 rute tunggal (`10.142.0.0 /22`).
    ```
    ip route 10.142.0.0 255.255.252.0 10.142.3.233
    ```

### 5. Menyalakan Interface (Penting!)
Semua interface yang dikonfigurasi di atas (Gi0/0, Gi0/1, Gi0/2, Se0/2/0, Vlan40, Vlan50 di Pusat, dan Gi0/0, Se0/0/0 di Cabang) harus dinyalakan menggunakan perintah **`no shutdown`**.

### 6. Konfigurasi Switch Eksternal
Dua switch (Sarpras & Server) yang terhubung ke module `HWIC-4ESW` perlu konfigurasi VLAN agar sesuai dengan router.
* **`Switch_Sarpras`:** Port yang terhubung ke router dan PC harus dimasukkan ke `VLAN 40`.
* **`Switch_Server_Admin`:** Port yang terhubung ke router dan PC harus dimasukkan ke `VLAN 50`.

### 7. Konfigurasi IP Host
Semua PC (host) dikonfigurasi secara statis dengan:
* **IP Address:** Alamat unik dari "Range Host" (misal: `10.142.0.10`).
* **Subnet Mask:** Sesuai dengan jaringannya (misal: `255.255.254.0`).
* **Default Gateway:** Alamat IP router di jaringan itu (misal: `10.142.0.1`).

---

## Validasi & Hasil Akhir

Konektivitas divalidasi menggunakan dua perintah utama:
1.  **`show ip interface brief`:** Memastikan semua interface yang digunakan (termasuk Serial dan Vlan) memiliki status `up` dan `up`.
2.  **`ping`:** Melakukan tes `ping` antar PC. Tes `ping` dari PC di jaringan Sekretariat (`10.142.0.10`) ke PC di jaringan Pengawas (`10.142.3.194`) berhasil, membuktikan seluruh topologi, VLSM, dan routing (termasuk CIDR) telah diimplementasikan dengan benar.
