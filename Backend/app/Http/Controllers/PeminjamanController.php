<?php

namespace App\Http\Controllers;

use App\Models\Buku;
use App\Models\Peminjaman;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PeminjamanController extends Controller
{
    public function pinjam($id){
        $pinjam = Buku::where('id',$id)->get();
        return view('perpus.pinjam', ['tampil' => $pinjam]);
    }

    public function pinjam_proses(Request $request){
        $request->validate([
            'tgl_pinjam' => 'required',
            'jumlah' => 'required|min:1',
        ],[
            'tgl_pinjam.required' => 'Tanggal Peminjaman tidak boleh kosong',
            'jumlah.required' => 'Jumlah Peminjaman tidak boleh kosong',
            'jumlah.min' => 'Minimal Meminjam 1 buku',
        ]);

        if($request->jumlah > $request->stok){
            return redirect('/perpus/buku/pinjam/'.$request->id_buku)->with('jumlah','Maaf Stok Buku Tidak tersedia');
        }else{
            Peminjaman::create([
                'id_user' => Auth::user()->id,
                'id_buku' => $request->id_buku,
                'tgl_pinjam' => $request->tgl_pinjam,
                'jumlah' => $request->jumlah,
                'statuspinjam' => 'konfirmasi',
            ]);

            return redirect('/perpus/peminjaman')->with('pinjam','Peminjaman Anda Sedang di proses tunggu');
        }
    }

    public function peminjaman(){
        $pinjam = Peminjaman::with(['user','buku'])->where('id_user',Auth::user()->id)->get();
        return view('perpus.peminjaman', ['tampil' => $pinjam]);
    }

    public function pengembalian(Request $request){
        Peminjaman::where('id',$request->id)->update([
            'tgl_kembali' => $request->tgl_kembali,
            'jumlah' => $request->jumlah,
            'statuspinjam' => 'dikembalikan',
        ]);

        return redirect('/perpus/peminjaman')->with('pengembalian','Buku Sudah Berrhasil Anda Kembalikan');
    }

    public function laporan(){
        $laporan = Peminjaman::with(['user','buku'])->get();
        return view('perpus.laporan', ['tampil' => $laporan]);
    }

    public function setujui(Request $request){
        Peminjaman::where('id',$request->id)->update([
            'statuspinjam' => 'disetujui',
        ]);

        return redirect('/perpus/laporan')->with('setujui','Anda telah menyetujui peminjaman');
    }

    public function tolak(Request $request){
        Peminjaman::where('id',$request->id)->update([
            'statuspinjam' => 'ditolak',
        ]);

        return redirect('/perpus/laporan')->with('tolak','Anda telah menolak peminjaman');
    }

    public function hapus(Request $request){
        Peminjaman::where('id',$request->id)->delete();
        return redirect('/perpus/laporan')->with('hapus','Peminjaman telah anda hapus');
    }
}
