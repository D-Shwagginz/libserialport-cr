
[![Ubuntu Build](https://github.com/D-Shwagginz/libserialport-cr/actions/workflows/ubuntu-build.yml/badge.svg)](https://github.com/D-Shwagginz/libserialport-cr/actions/workflows/ubuntu-build.yml)
[![Windows Build](https://github.com/D-Shwagginz/libserialport-cr/actions/workflows/windows-build.yml/badge.svg)](https://github.com/D-Shwagginz/libserialport-cr/actions/workflows/windows-build.yml)

[![Ubuntu Emulation Test](https://github.com/D-Shwagginz/libserialport-cr/actions/workflows/ubuntu-emulation-test.yml/badge.svg)](https://github.com/D-Shwagginz/libserialport-cr/actions/workflows/ubuntu-emulation-test.yml)

# libserialport-cr

A Crystal C-Binding library of [libserialport](https://sigrok.org/wiki/Libserialport)

"libserialport (sometimes abbreviated as "sp") is a minimal, cross-platform shared library written in C that is intended to take care of the OS-specific details when writing software that uses serial ports."

## Installation

### Linux

1. Run
```sh
sudo sh ./rsrc/install.sh
```
2. Add `libserialport-cr` to your `shard.yml` dependencies like so:
```yml
dependencies:
  libserialport-cr:
    github: D-Shwagginz/libserialport-cr
```

### Windows

1. Follow the instructions at https://github.com/neatorobito/scoop-crystal to add the crystal-preview bucket to scoop
2. Install crystal with `scoop install crystal`
3. Run `.\rsrc\install.ps1` in powershell
4. Run in powershell
```powershell
$env:LIB="${env:LIB};C:\libserialport"
$env:PATH="${env:PATH};C:\libserialport"
```

OR

Run in cmd
```cmd
set PATH=%PATH%;C:\libserialport
set LIB=%LIB%;C:\libserialport
```

## Usage

  For usage, see the 1 to 1 [examples](https://github.com/D-Shwagginz/libserialport-cr/tree/master/examples) recreated from libserialport.

## Contributing

1. Fork it (<https://github.com/your-github-user/libserialport-cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [D. Shwagginz](https://github.com/your-github-user) - creator and maintainer
