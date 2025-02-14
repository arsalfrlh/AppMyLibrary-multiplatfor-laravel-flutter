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
        <div class="row">
            <div class="col-md-6">
                <center><h1 class="mt-5">User Profile</h1></center>
                <form class="mt-3" method="POST" action="/perpus/profile/update">
                    @method('PUT')
                    @csrf
                    @if ($errors->any())
                        <div class="pt-3">
                            <div class="alert alert-danger">
                                <ul>
                                    @foreach ($errors->all() as $item)
                                        <li>{{ $item }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        </div>
                    @endif
                    @foreach ($tampil as $anggota)
                    <div class="form-group mt-2">
                        <img src="{{ asset('images/profile.png') }}" class="rounded mx-auto d-block" alt="..." width="100px" style="border-radius: 50%">
                      </div>
                    <div class="form-group mt-2">
                        <label for="inputAddress">Nama</label>
                        <input type="text" class="form-control" id="inputAddress" name="nama" value="{{ $anggota->name }}">
                      </div>
                    <div class="form-group">
                      <label for="inputAddress">Email</label>
                      <input type="text" class="form-control" id="inputAddress" name="email" value="{{ $anggota->email }}">
                    </div>
                    <div class="form-group">
                        <label for="inputAddress">Alamat</label>
                        <input type="text" class="form-control" id="inputAddress" name="alamat" value="{{ $anggota->alamat }}">
                      </div>
                    <div class="form-group">
                        <label for="inputAddress">Password</label>
                        <input type="number" class="form-control" id="inputAddress" name="password">
                      </div>
                      @endforeach
                    <button type="submit" class="btn btn-success">Simpan</button> <a href="/perpus/anggota" class="btn btn-primary">Kembali</a>
                  </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    @if ($pesan = Session::get('updateprofile'))
        <script>Swal.fire('{{ $pesan }}');</script>
    @endif

    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>