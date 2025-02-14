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
                <center><h1 class="mt-5">Peminjaman Buku</h1></center>
                <form class="mt-3" method="POST" action="/perpus/pinjam/proses">
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
                    @foreach ($tampil as $pinjam)
                    <div class="form-group mt-2">
                        <img src="{{ asset('images/'.$pinjam->gambar) }}" class="rounded mx-auto d-block" alt="..." width="100px" style="border-radius: 50%">
                      </div>
                      <div class="form-group mt-2">
                        <label for="inputAddress">Nama Peminjam</label>
                        <input type="text" class="form-control" id="inputAddress" name="nama" value="{{ Auth::user()->name }}" readonly>
                      </div>
                    <div class="form-group mt-2">
                        <label for="inputAddress">Judul</label>
                        <input type="text" class="form-control" id="inputAddress" name="judul" value="{{ $pinjam->judul }}" readonly>
                        <input type="hidden" name="id_buku" value="{{ $pinjam->id }}">
                      </div>
                      <div class="form-group mt-2">
                        <label for="inputAddress">Penulis</label>
                        <input type="text" class="form-control" id="inputAddress" name="penulis" value="{{ $pinjam->penulis }}" readonly>
                      </div>
                    <div class="form-group">
                      <label for="inputAddress">Tanggal Pinjam</label>
                      <input type="date" class="form-control" id="inputAddress" name="tgl_pinjam">
                    </div>
                    <div class="form-group">
                        <label for="inputAddress">Jumlah Pinjam</label>
                        <input type="number" class="form-control" id="inputAddress" name="jumlah" value="{{ $pinjam->stok }}">
                        <input type="hidden" value="{{ $pinjam->stok }}" name="stok">
                      </div>
                      @endforeach
                    <button type="submit" class="btn btn-success">Pinjam</button> <a href="/perpus/buku" class="btn btn-primary">Kembali</a>
                  </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    @if ($pesan = Session::get('jumlah'))
        <script>Swal.fire('{{ $pesan }}');</script>
    @endif
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>