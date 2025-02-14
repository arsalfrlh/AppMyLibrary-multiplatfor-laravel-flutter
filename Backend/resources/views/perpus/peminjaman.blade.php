<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<body>
    <div class="container">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo01" aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarTogglerDemo01">
            <a class="navbar-brand" href="#">Buku Online</a>
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
            <li class="nav-item">
                <a class="nav-link" href="/perpus/index">Home <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/perpus/anggota">Anggota</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/perpus/buku">Buku</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="/perpus/peminjaman">Peminjaman</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/perpus/laporan">Laporan</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/perpus/logout">Logout</a>
            </li>
            </ul>
        </div>
        </nav>

        <br>
        <div class="row">
            <div class="col-md-12">
            <div class="container">
            <h1 class="text-center mt-3">Daftar Buku</h1>
            <!-- Daftar Barang -->
            <div class="row row-cols-1 row-cols-md-5 g-4">
                <table class="table">
                    <thead class="thead-dark">
                      <tr>
                        <th scope="col">No</th>
                        <th scope="col">Gambar</th>
                        <th scope="col">Judul</th>
                        <th scope="col">Jumlah Pinjam</th>
                        <th scope="col">Tanggal Pinjam</th>
                        <th scope="col">Tanggal Kembali</th>
                        <th scope="col">Status Peminjaman</th>
                        <th scope="col">Aksi</th>
                      </tr>
                    </thead>
                    <tbody>
                        @php
                            $no = 1;
                        @endphp
                        @foreach ($tampil as $pinjam) 
                        <tr>
                            <th scope="row">{{ $no++ }}</th>
                            <td><img src="{{ asset('images/'.$pinjam->buku->gambar) }}" width="80px"></td>
                            <td>{{ $pinjam->buku->judul }}</td>
                            <td>{{ $pinjam->jumlah }}</td>
                            <td>{{ $pinjam->tgl_pinjam }}</td>
                            <td>{{ $pinjam->tgl_kembali }}</td>
                            <td>@if ($pinjam->statuspinjam == "konfirmasi")
                                <span class="badge btn-warning">Menunggu Konfirmasi</span>
                                @elseif ($pinjam->statuspinjam == "disetujui")
                                <span class="badge btn-primary">Peminjaman disetujui</span>
                                @elseif ($pinjam->statuspinjam == "ditolak")
                                <span class="badge btn-danger">Peminjaman ditolak</span>
                                @elseif ($pinjam->statuspinjam == "dikembalikan")
                                <span class="badge btn-info">Buku dikembalikan</span>
                                @else
                                <span class="badge btn-warning">Terdapat Masalah</span>
                            @endif</td>
                            <td>
                                @if ($pinjam->statuspinjam == "disetujui")
                                <form action="/perpus/peminjaman/pengembalian" method="POST">
                                    @csrf
                                    @method('PUT')
                                    <input type="hidden" value="{{ $pinjam->id }}" name="id" readonly>
                                    <input type="date" hidden="hidden" name="tgl_kembali" id="tanggal" readonly>
                                    <input type="hidden" value="{{ $pinjam->jumlah }}" name="jumlah" readonly>
                                    <input type="submit" value="Kembalikan" class="btn btn-success">
                                </form>
                                @endif
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                  </table>
            </div>
        </div>
    </div>
</div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    @if ($pesan = Session::get('pinjam'))
        <script>Swal.fire('{{ $pesan }}');</script>
    @endif

    @if ($pesan = Session::get('pengembalian'))
        <script>
            Swal.fire({
            position: "top-center",
            icon: "success",
            title: '{{ $pesan }}',
            showConfirmButton: false,
            timer: 1500
            });
        </script>
    @endif

    <script>
        // Fungsi untuk mendapatkan tanggal sekarang dalam format YYYY-MM-DD
        function getFormattedDate() {
          const now = new Date();
          const year = now.getFullYear();
          const month = String(now.getMonth() + 1).padStart(2, '0');
          const day = String(now.getDate()).padStart(2, '0');
          return `${year}-${month}-${day}`;
        }
    
        // Fungsi untuk mengatur nilai input tanggal secara otomatis
        function updateDate() {
          const tanggalInput = document.getElementById('tanggal');
          tanggalInput.value = getFormattedDate();
        }
    
        // Panggil fungsi pertama kali
        updateDate();
    
        // Atur interval agar tanggal diperbarui setiap hari
        setInterval(updateDate, 24 * 60 * 60 * 1000); // 24 jam * 60 menit * 60 detik * 1000 milidetik
      </script>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>