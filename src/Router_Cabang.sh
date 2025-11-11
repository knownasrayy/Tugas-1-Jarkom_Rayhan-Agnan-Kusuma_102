enable
configure terminal

! --- KONFIGURASI DASAR ---
hostname Router_Cabang
no ip domain-lookup

! --- 1. LAN PENGAWAS (Routed Port) ---
interface GigabitEthernet0/0
 description LAN-Pengawas (Gateway: 10.142.3.193)
 ip address 10.142.3.193 255.255.255.224
 no shutdown
 exit

! --- 2. INTERFACE WAN (KE PUSAT) ---
! (Asumsi portnya Serial0/0/0)
interface Serial0/0/0
 description Link-WAN-ke-Pusat (DTE)
 ip address 10.142.3.234 255.255.255.252
 no clock rate
 no shutdown
 exit

! --- 3. STATIC ROUTING (SUPERNET/CIDR) ---
! (Mengajari router cara ke SEMUA 5 jaringan di Pusat)
ip route 10.142.0.0 255.255.252.0 10.142.3.233

! --- SIMPAN KONFIGURASI ---
end
write memory