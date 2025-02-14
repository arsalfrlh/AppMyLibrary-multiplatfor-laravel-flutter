<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Buku;
use App\Models\Peminjaman;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class SessionController extends Controller
{
    public function login(){
        return view('perpus.login');
    }

    public function login_proses(Request $request){
        $request->validate([
            'email' => 'required',
            'password' => 'required',
        ],[
            'email.required' => 'Email Tidak boleh kosong',
            'password.required' => 'Password Tidak boleh kosong',
        ]);

        $cek_login = [
            'email' => $request->email,
            'password' => $request->password,
        ];

        if(Auth::attempt($cek_login)){
            return redirect('/perpus/index')->with('login', Auth::user()->name .'Anda Berhasil Login');
        }else{
            return redirect('/perpus/login')->with('gagal','Email atau Password Anda salah');
        }
    }

    public function register(){
        return view('perpus.register');
    }

    public function register_proses(Request $request){
        $request->validate([
            'nama' => 'required',
            'email' => 'required|email|unique:users',
            'alamat' => 'required',
            'password' => 'required|min:3',
        ],[
            'nama.required' => 'Nama Tidak boleh kosong',
            'alamat.required' => 'Alamat Tidak boleh kosong',
            'email.required' => 'Email Tidak boleh kosong',
            'email.email' => 'Email yang digunakan harus valid',
            'email.unique' => 'Email sudah digunakan',
            'password.required' => 'Password Tidak boleh kosong',
            'password.min' => 'Minimal 3 karakter',
        ]);

        User::create([
            'name' => $request->nama,
            'alamat' => $request->alamat,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $cek_login = [
            'email' => $request->email,
            'password' => $request->password,
        ];

        if(Auth::attempt($cek_login)){
            return redirect('/perpus/index')->with('login', Auth::user()->name .' Anda Berhasil Register');
        }else{
            return redirect('/perpus/login')->with('gagal','Email atau Password Anda salah');
        }
    }

    public function logout(){
        Auth::logout();
        return redirect('/perpus/login')->with('logout','Anda Berhasil Logout');
    }

    public function index(){
        $jml_user = User::count();
        $jml_buku = Buku::count();
        $jml_pinjam = Peminjaman::with(['user'])->where('id_user',Auth::user()->id)->count();
        $all_pinjam = Peminjaman::count();
        return view('perpus.index',['jumlah_user' => $jml_user, 'jumlah_buku' => $jml_buku, 'jumlah_pinjam' => $jml_pinjam, 'all_pinjam' => $all_pinjam]);
    }
}
