<?php

namespace App\Http\Controllers;

use App\Models\Buku;
use Illuminate\Http\Request;

class BukuController extends Controller
{
    public function buku(Request $request){
        $cari = $request->cari;
        $jumlahbaris = 3;
        if(strlen($cari)){
            $buku = Buku::where('judul','like',"%$cari%")->orWhere('penulis','like',"%$cari%")->paginate($jumlahbaris);
        }else{
            $buku = Buku::paginate(3); //menampilkan 3 data untuk 1 halaman confignya ada di "AppServiceProvider"
        }
        return view('perpus.buku',[ 'tampil' => $buku ]);
    }

    public function tambah_buku(){
        return view('perpus.tambah_buku');
    }

    public function create_buku(Request $request){
        $request->validate([
            'gambar' => 'required|image|mimes:jpg,png,jpeg|max:2048',
            'judul' => 'required',
            'penulis' => 'required',
            'stok' => 'required',
        ],[
            'gambar.required' => 'File tidak boleh kosong',
            'gambar.image' => 'File harus berupa gambar',
            'gambar.mimes' => 'File harus bertype png, jpg, jpeg',
            'gambar.max' => 'File maximum size hanya 2mb',
            'judul.required' => 'judul tidak boleh kosong',
            'penulis.required' => 'Penulis tidak boleh kosong',
            'stok.required' => 'Stok tidak boleh kosong',
        ]);

        if($request->hasFile('gambar')){
            $gambar = $request->file('gambar');
            $nm_gambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nm_gambar);
        }else{
            $nm_gambar = null;
        }

        Buku::create([
            'gambar' => $nm_gambar,
            'judul' => $request->judul,
            'penulis' => $request->penulis,
            'stok' => $request->stok,
        ]);

        return redirect('/perpus/buku')->with('tambahbuku','Menambahkan Buku Berhasil');
    }

    public function edit_buku($id){
        $buku = Buku::where('id',$id)->get();
        return view('perpus.edit_buku',[ 'tampil' => $buku ]);
    }

    public function update_buku(Request $request){
        $request->validate([
            'gambar' => 'image|mimes:jpg,png,jpeg|max:2048',
            'judul' => 'required',
            'penulis' => 'required',
            'stok' => 'required',
        ],[
            'gambar.required' => 'File tidak boleh kosong',
            'gambar.image' => 'File harus berupa gambar',
            'gambar.mimes' => 'File harus bertype png, jpg, jpeg',
            'judul.max' => 'File maximum size hanya 2mb',
            'judul.required' => 'judul tidak boleh kosong',
            'penulis.required' => 'Penulis tidak boleh kosong',
            'stok.required' => 'Stok tidak boleh kosong',
        ]);

        $buku = Buku::where('id',$request->id_buku)->first();
        if($request->hasFile('gambar')){
            if($buku->gambar && file_exists(public_path('images/'.$buku->gambar))){
                unlink(public_path('images/'.$buku->gambar));
            }

            $gambar = $request->file('gambar');
            $nm_gambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nm_gambar);
        }else{
            $nm_gambar = $buku->gambar;
        }

        Buku::where('id',$request->id_buku)->update([
            'gambar' => $nm_gambar,
            'judul' => $request->judul,
            'penulis' => $request->penulis,
            'stok' => $request->stok,
        ]);

        return redirect('/perpus/buku')->with('editbuku','Mengubah data buku berhasil');
    }

    public function hapus($id){
        $buku = Buku::where('id',$id)->first();
        if($buku->gambar && file_exists(public_path('images/'.$buku->gambar))){
            unlink(public_path('images/'.$buku->gambar));
        }
        Buku::where('id',$id)->delete();

        return redirect('/perpus/buku')->with('hapusbuku','Berhasi menghapus buku');
    }
}
