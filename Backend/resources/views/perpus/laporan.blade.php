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
            <li class="nav-item">
                <a class="nav-link" href="/perpus/peminjaman">Peminjaman</a>
            </li>
            <li class="nav-item active">
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
                        <th scope="col">Nama</th>
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
                        @foreach ($tampil as $laporan) 
                        <tr>
                            <th scope="row">{{ $no++ }}</th>
                            <td><img src="{{ asset('images/'.$laporan->buku->gambar) }}" width="80px"></td>
                            <td>{{ $laporan->user->name }}</td>
                            <td>{{ $laporan->buku->judul }}</td>
                            <td>{{ $laporan->jumlah }}</td>
                            <td>{{ $laporan->tgl_pinjam }}</td>
                            <td>{{ $laporan->tgl_kembali }}</td>
                            <td>@if ($laporan->statuspinjam == "konfirmasi")
                                <span class="badge btn-warning">Menunggu Konfirmasi</span>
                                @elseif ($laporan->statuspinjam == "disetujui")
                                <span class="badge btn-primary">Peminjaman disetujui</span>
                                @elseif ($laporan->statuspinjam == "ditolak")
                                <span class="badge btn-danger">Peminjaman ditolak</span>
                                @elseif ($laporan->statuspinjam == "dikembalikan")
                                <span class="badge btn-info">Buku dikembalikan</span>
                                @else
                                <span class="badge btn-warning">Terdapat Masalah</span>
                            @endif</td>
                            <td>
                                @if ($laporan->statuspinjam == "konfirmasi")
                                <form action="/perpus/laporan/setujui" method="POST">
                                    @csrf
                                    @method('PUT')
                                    <input type="hidden" value="{{ $laporan->id }}" name="id" readonly>
                                    <input type="submit" value="Setujui" class="btn btn-primary">
                                </form>
                                <form action="/perpus/laporan/tolak" method="POST" class="mt-1">
                                    @csrf
                                    @method('PUT')
                                    <input type="hidden" value="{{ $laporan->id }}" name="id" readonly>
                                    <input type="submit" value="Tolak" class="btn btn-warning">
                                </form>
                                @endif
                                <form action="/perpus/laporan/hapus" method="POST" class="mt-1">
                                    @csrf
                                    @method('DELETE')
                                    <input type="hidden" value="{{ $laporan->id }}" name="id" readonly>
                                    <button type="button" class="btn btn-danger btn-delete">Hapus</button>
                                </form>
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

    @if ($pesan = Session::get('setujui'))
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

    @if ($pesan = Session::get('tolak'))
        <script>
            Swal.fire({
            icon: "error",
            title: "DITOLAK!",
            text: '{{ $pesan }}',
            });
        </script>
    @endif

    <script type="text/javascript">
        $(function(){
            $(document).on('click', '.btn-delete', function(e){ //nama button di form hapus
                e.preventDefault();
                var form = $(this).closest('form'); // Mendapatkan form terdekat

                Swal.fire({
                    title: "Are you sure?",
                    text: "You won't be able to revert this!",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Yes, delete it!"
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit(); // Menjalankan submit form jika konfirmasi
                    }
                });
            });
        });
    </script>

    @if ($pesan = Session::get('hapus'))
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

    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>