enable
configure terminal

! --- Buat VLAN 40 ---
vlan 40
 name Sarpras
 exit

! --- Port yang ke Router_Pusat ---
! (Asumsi kamu pakai port Fa0/1 di switch ini)
interface FastEthernet0/1
 description Ke-Router_Pusat
 switchport mode access
 switchport access vlan 40
 no shutdown
 exit

! --- Port yang ke PC Sarpras ---
! (Ini akan setting semua port LAINNYA ke VLAN 40)
interface range FastEthernet 0/2 - 24
 description Ke-PC-Sarpras
 switchport mode access
 switchport access vlan 40
 no shutdown
 exit

end
write memory