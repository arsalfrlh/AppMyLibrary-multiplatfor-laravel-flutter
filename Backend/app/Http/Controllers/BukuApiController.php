<?php

namespace App\Http\Controllers;

use App\Models\Buku;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class BukuApiController extends Controller
{
    public function index(){
        $data = Buku::all();
        return response()->json(['sukses' => true, 'pesan' => 'berhasil menampilkan data buku', 'data' => $data]);
    }

    public function cari(Request $request){
        $cari = $request->cari;
        if(strlen($cari)){
            $data = Buku::where('judul','like',"%$cari%")->orWhere('penulis','like',"%$cari%")->get();
        }else{
            $data = null;
        }
        return response()->json(['sukses' => true, 'pesan' => 'Menampilkan hasil pencarian', 'data' => $data]);
    }

    public function create_buku(Request $request){
        $validator = Validator::make($request->all(),[
            'gambar' => 'image|mimes:jpg,png,jpeg|max:2048',
            'judul' => 'required',
            'penulis' => 'required',
            'stok' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['sukses' => false, 'pesan' => 'ada kesalahan', 'data' => $validator->errors()]);
        }

        if($request->hasFile('gambar')){
            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = null;
        }

        $data = Buku::create([
            'gambar' => $nmgambar,
            'judul' => $request->judul,
            'penulis' => $request->penulis,
            'stok' => $request->stok,
        ]);

        return response()->json(['sukses' => true, 'pesan' => 'berhasil menambahkan data buku', 'data' => $data]);
    }

    public function edit_buku($id){
        $data = Buku::where('id',$id)->get();
        return response()->json(['sukses' => true, 'pesan' => 'berhasil menampilkan data buku yang dipilih', 'data' => $data]);
    }

    public function update_buku(Request $request,$id){
        $validator = Validator::make($request->all(),[
            'judul' => 'required',
            'penulis' => 'required',
            'stok' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['sukses' => false, 'pesan' => 'ada kesalahan', 'data' => $validator->errors()]);
        }

        $buku = Buku::where('id',$id)->first();
        if($request->hasFile('gambar')){
            if($buku->gambar && file_exists(public_path('images/'.$buku->gambar))){
                unlink(public_path('images/'.$buku->gambar));
            }

            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = $buku->gambar;
        }

        $data = Buku::where('id',$id)->update([
            'gambar' => $nmgambar,
            'judul' => $request->judul,
            'penulis' => $request->penulis,
            'stok' => $request->stok,
        ]);

        return response()->json(['sukses' => true, 'pesan' => 'Berhasil mengupdate data buku', 'data' => $data]);
    }

    public function hapus_buku($id){
        $buku = Buku::where('id',$id)->first();
        if($buku->gambar && file_exists(public_path('images/'.$buku->gambar))){
            unlink(public_path('images/'.$buku->gambar));
        }

        $data = Buku::where('id',$id)->delete();
        return response()->json(['sukses' => true, 'pesan' => 'berhasil menghapus data buku', 'data' => $data]);
    }
}
