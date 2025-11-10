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
| Bidang Guru & Tendik | 95 host |
| Bidang Kurikulum | 220 host |
| Bidang Sarana Prasarana | 45 host |
| Bidang Pengawas Sekolah (Branch) | 18 host |
| Server & Admin | 6 host |

| Sekretariat | 380 host |
| :--- | :--- |

<br>

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

| Kebutuhan Ruang | Jml Host | Host Dibutuhkan (Host+Net+BC) | Ukuran Blok (2^n) | Prefix (/) | Subnet Mask | Network Address | Range Host (Usable) | Broadcast Address |
| :--- | :---: | :---: | :---: | :---: | :--- | :--- | :--- | :--- |
| **Sekretariat** | 380 | $380+2=382$ | 512 (2^9) | /23 | `255.255.254.0` | **`10.142.0.0`** | `10.142.0.1` - `10.142.1.254` | `10.142.1.255` |
| **Bidang Kurikulum** | 220 | $220+2=222$ | 256 (2^8) | /24 | `255.255.255.0` | **`10.142.2.0`** | `10.142.2.1` - `10.142.2.254` | `10.142.2.255` |
| **Bid. Guru & Tendik**| 95 | $95+2=97$ | 128 (2^7) | /25 | `255.255.255.128` | **`10.142.3.0`** | `10.142.3.1` - `10.142.3.126` | `10.142.3.127` |
| **Bid. Sarpras** | 45 | $45+2=47$ | 64 (2^6) | /26 | `255.255.255.192` | **`10.142.3.128`**| `10.142.3.129` - `10.142.3.190` | `10.142.3.191` |
| **Bid. Pengawas** | 18 | $18+2=20$ | 32 (2^5) | /27 | `255.255.255.224` | **`10.142.3.192`**| `10.142.3.193` - `10.142.3.222` | `10.142.3.223` |
| **Server & Admin** | 6 | $6+2=8$ | 8 (2^3) | /29 | `255.255.255.248` | **`10.142.3.224`**| `10.142.3.225` - `10.142.3.230` | `10.142.3.231` |
| **Link WAN** | 2 | $2+2=4$ | 4 (2^2) | /30 | `255.255.255.252` | **`10.142.3.232`**| `10.142.3.233` - `10.142.3.234` | `10.142.3.235` |

---

## Objektif Implementasi

1.  Rancanglah topologinya menggunakan **Cisco Packet Tracer**.
2.  Lakukan **perhitungan subnetting dengan VLSM & CIDR** di Spreadsheet.
3.  Konfigurasikan **alamat IP** di setiap interface router dan host pada CPT sesuai tabel hasil subnetting di atas.
