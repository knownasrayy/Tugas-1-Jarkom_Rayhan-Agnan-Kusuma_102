enable
configure terminal

! --- KONFIGURASI DASAR ---
hostname Router_Pusat
no ip domain-lookup

! --- 1. LAN SEKRETARIAT (Routed Port) ---
interface GigabitEthernet0/0
 description LAN-Sekretariat (380 host)
 ip address 10.142.0.1 255.255.254.0
 no shutdown
 exit

! --- 2. LAN KURIKULUM (Routed Port) ---
interface GigabitEthernet0/1
 description LAN-Kurikulum (220 host)
 ip address 10.142.2.1 255.255.255.0
 no shutdown
 exit

! --- 3. LAN GURU & TENDIK (Routed Port) ---
interface GigabitEthernet0/2
 description LAN-Guru-Tendik (95 host)
 ip address 10.142.3.1 255.255.255.128
 no shutdown
 exit

! --- 4. LAN SARPRAS (via SVI) ---
! Pertama, buat Interface Virtual (SVI) untuk Gateway
interface Vlan40
 description Gateway-LAN-Sarpras (45 host)
 ip address 10.142.3.129 255.255.255.192
 no shutdown
 exit
! Kedua, masukkan Port Fisik (dari module HWIC-4ESW) ke VLAN 40
! (Pastikan nama port Fa0/3/0 ini sesuai dengan di CPT-mu)
interface FastEthernet0/3/0
 description Ke-Switch-Sarpras
 switchport mode access
 switchport access vlan 40
 no shutdown
 exit

! --- 5. LAN SERVER & ADMIN (via SVI) ---
! Pertama, buat Interface Virtual (SVI) untuk Gateway
interface Vlan50
 description Gateway-LAN-Server-Admin (6 host)
 ip address 10.142.3.225 255.255.255.248
 no shutdown
 exit
! Kedua, masukkan Port Fisik (dari module HWIC-4ESW) ke VLAN 50
! (Pastikan nama port Fa0/3/1 ini sesuai)
interface FastEthernet0/3/1
 description Ke-Switch-Server-Admin
 switchport mode access
 switchport access vlan 50
 no shutdown
 exit

! --- 6. INTERFACE WAN (KE CABANG) ---
! (Pastikan nama port Serial0/2/0 ini sesuai)
interface Serial0/2/0
 description Link-WAN-ke-Cabang (DCE)
 ip address 10.142.3.233 255.255.255.252
 clock rate 64000
 no shutdown
 exit

! --- 7. STATIC ROUTING ---
! (Mengajari router ini cara ke jaringan Pengawas di Cabang)
ip route 10.142.3.192 255.255.255.224 10.142.3.234

! --- SIMPAN KONFIGURASI ---
end
write memory
