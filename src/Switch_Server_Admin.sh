enable
configure terminal

! --- Buat VLAN 50 ---
vlan 50
 name Server_Admin
 exit

! --- Port yang ke Router_Pusat ---
! (Asumsi kamu pakai port Fa0/1 di switch ini)
interface FastEthernet0/1
 description Ke-Router_Pusat
 switchport mode access
 switchport access vlan 50
 no shutdown
 exit

! --- Port yang ke PC/Server Admin ---
! (Ini akan setting semua port LAINNYA ke VLAN 50)
interface range FastEthernet 0/2 - 24
 description Ke-PC-Admin
 switchport mode access
 switchport access vlan 50
 no shutdown
 exit

end
write memory