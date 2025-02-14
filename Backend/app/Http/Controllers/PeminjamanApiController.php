<?php

namespace App\Http\Controllers;

use App\Models\Buku;
use App\Models\Peminjaman;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PeminjamanApiController extends Controller
{
    public function daftar_pinjam($id){
        $data = Peminjaman::with(['user','buku'])->where('id_user',$id)->get();
        return response()->json(['message' => 'Berhasil menampilkan daftar peminjaman anda', 'success' => true, 'data' => $data]);
    }

    public function pinjam(Request $request,$id){
        $validator = Validator::make($request->all(),[
            'tgl_pinjam' => 'required',
            'jumlah' => 'required|min:1',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        $buku = Buku::where('id',$request->id_buku)->first();
        if($request->jumlah > $buku->stok){
            return response()->json(['message' => 'Maaf stok buku tidak tersedia', 'success' => false, 'data' => null]);
        }

        $data = Peminjaman::create([
            'id_user' => $id,
            'id_buku' => $request->id_buku,
            'tgl_pinjam' => $request->tgl_pinjam,
            'jumlah' => $request->jumlah,
            'statuspinjam' => 'konfirmasi',
        ]);

        return response()->json(['message' => 'Peminjaman anda sedang di proses mohon tunggu', 'success' => true, 'data' => $data]);
    }

    public function pengembalian(Request $request,$id){
        $validator = Validator::make($request->all(),[
            'tgl_kembali' => 'required',
            'jumlah' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()]);
        }

        $data = Peminjaman::where('id',$id)->update([
            'tgl_kembali' => $request->tgl_kembali,
            'jumlah' => $request->jumlah,
            'statuspinjam' => 'dikembalikan',
        ]);

        return response()->json(['message' => 'Buku berhasil dikembalikan', 'success' => true, 'data' => $data]);
    }

    public function laporan(){
        $data = Peminjaman::with('user','buku')->get();
        return response()->json(['message' => 'Berhasil menampilkan semua data Peminjaman', 'success' => true, 'data' => $data]);
    }

    public function setuju($id){
        $data = Peminjaman::where('id',$id)->update([
            'statuspinjam' => 'disetujui',
        ]);

        return response()->json(['message' => 'Anda telah menyetujui peminjaman', 'success' => true, 'data' => $data]);
    }

    public function tolak($id){
        $data = Peminjaman::where('id',$id)->update([
            'statuspinjam' => 'ditolak',
        ]);

        return response()->json(['message' => 'Anda telah menolak peminjaman', 'success' => true, 'data' => $data]);
    }

    public function hapus($id){
        $data = Peminjaman::where('id',$id)->delete();
        return response()->json(['message' => 'Peminjaman berhasil dihapus', 'success' => true, 'data' => $data]);
    }

}
