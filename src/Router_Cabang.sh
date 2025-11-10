enable
configure terminal

! --- KONFIGURASI DASAR ---
hostname Router_Cabang
no ip domain-lookup

! --- 1. LAN PENGAWAS (Routed Port) ---
interface GigabitEthernet0/0
 description LAN-Pengawas (18 host)
 ip address 10.142.3.193 255.255.255.224
 no shutdown
 exit

! --- 2. INTERFACE WAN (KE PUSAT) ---
! (Pastikan nama port Serial0/0/0 ini sesuai)
interface Serial0/0/0
 description Link-WAN-ke-Pusat (DTE)
 ip address 10.142.3.234 255.255.255.252
 no shutdown
 exit

! --- 3. STATIC ROUTING (SUPERNET) ---
! (Mengajari router ini cara ke SEMUA 5 jaringan di Pusat pakai 1 baris)
ip route 10.142.0.0 255.255.252.0 10.142.3.233

! --- SIMPAN KONFIGURASI ---
end
write memory
