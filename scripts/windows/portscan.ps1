$ip=$args[0]

For ($i=1; $i -le 65535; $i++) {
  Test-NetConnection -Port $i -ComputerName $ip -WarningAction SilentlyContinue | Select RemotePort,TcpTestSucceeded | Select-String -Pattern "True"
}
