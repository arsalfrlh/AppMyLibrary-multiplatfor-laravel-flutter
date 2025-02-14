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
            <li class="nav-item active">
                <a class="nav-link" href="/perpus/buku">Buku</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/perpus/peminjaman">Peminjaman</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/perpus/laporan">Laporan</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/perpus/logout">Logout</a>
            </li>
            </ul>
            <form class="form-inline my-2 my-lg-0" action="/perpus/buku" method="GET">
                @csrf
            <input class="form-control mr-sm-2" type="search" placeholder="Search" name="cari" value="{{ Request::get('cari') }}" aria-label="Search">
            <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </div>
        </nav>

        <br>
        <div class="row">
            <div class="col-md-12">
            <div class="container">
            <h1 class="text-center mt-3">Daftar Buku</h1>
    
            <!-- Form Tambah Barang -->
            <a href="/perpus/buku/tambah" class="btn btn-success mb-3">Tambah buku</a>
    
            <!-- Daftar Barang -->
            <div class="row row-cols-1 row-cols-md-5 g-4">
                @foreach ($tampil as $buku)
                <div data-aos="fade-up" data-aos-anchor-placement="top-center">
                <div class="col mt-3" style="height: 100%;">
                    <div class="card" style="width: 16rem;">
                    <img class="card-img-top" src="{{ asset('images/'.$buku->gambar) }}" alt="Card image cap">
                    <div class="card-body">
                        <h5 class="card-title">{{ $buku->judul }}</h5>
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">Penulis: {{ $buku->penulis }}</li>
                        <li class="list-group-item">Stok: {{ $buku->stok }}</li>
                    </ul>
                    <div class="card-body">
                        <a href="/perpus/buku/edit/{{ $buku->id }}" class="btn btn-primary">Edit</a>
                        <a href="/perpus/buku/pinjam/{{ $buku->id }}" class="btn btn-warning">Pinjam</a>
                        <form action="/perpus/buku/hapus/{{ $buku->id }}" class="d-inline" method="POST">
                            @csrf
                            @method('DELETE')
                            <button type="button" class="btn btn-danger btn-delete">Hapus</button>
                        </form>
                    </div>
                    </div>
                </div>
                </div>
                @endforeach
            </div>
            <br>
            {{ $tampil->links() }}
        </div>
    </div>
</div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    @if ($pesan = Session::get('tambahbuku'))
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

    @if ($pesan = Session::get('editbuku'))
        <script>Swal.fire('{{ $pesan }}');</script>
    @endif

    @if ($pesan = Session::get('hapusbuku'))
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

    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>