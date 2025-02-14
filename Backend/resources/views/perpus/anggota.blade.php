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
            <li class="nav-item active">
                <a class="nav-link" href="/perpus/anggota">Anggota</a>
            </li>
            <li class="nav-item">
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
            <form class="form-inline my-2 my-lg-0" action="/perpus/anggota" method="GET">
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
            <h1 class="text-center mt-3">Daftar Anggota</h1>
    
            <a href="/perpus/profile/edit" class="btn btn-success mb-3">Profile Saya</a>
            <!-- Daftar Anggota -->
            <div class="row row-cols-1 row-cols-md-5 g-4">
                <table class="table mt-3">
                    <thead class="thead-dark">
                      <tr>
                        <th scope="col">No</th>
                        <th scope="col">Nama</th>
                        <th scope="col">Email</th>
                        <th scope="col">Alamat</th>
                      </tr>
                    </thead>
                    <tbody>
                        @php
                            $no = 1;
                        @endphp
                        @foreach ($tampil as $anggota)
                        <tr class="table-secondary">
                            <th scope="row">{{ $no++ }}</th>
                            <td>{{ $anggota->name }}</td>
                            <td>{{ $anggota->email }}</td>
                            <td>{{ $anggota->alamat }}</td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
            </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>