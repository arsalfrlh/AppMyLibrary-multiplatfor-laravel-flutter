<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AnggotaController extends Controller
{
    public function anggota(Request $request){
        $cari = $request->cari;
        if(strlen($cari)){
            $user = User::where('name','like',"%$cari%")->orWhere('alamat','like',"%$cari%")->get();
        }else{
            $user = User::orderBy('id','desc')->get();
        }
        return view('perpus.anggota', [ 'tampil' => $user ]);
    }

    public function profile(){
        $user = User::where('id',Auth::user()->id)->get();
        return view('perpus.profile', [ 'tampil' => $user ]);
    }

    public function update_profile(Request $request){
        if($request->email == Auth::user()->email ){
            $request->validate([
                'nama' => 'required',
                'email' => 'required|email',
                'alamat' => 'required',
            ],[
                'nama.required' => 'Nama Tidak boleh kosong',
                'alamat.required' => 'Alamat Tidak boleh kosong',
                'email.required' => 'Email Tidak boleh kosong',
                'email.email' => 'Email yang digunakan harus valid',
            ]);
        }else{
            $request->validate([
                'nama' => 'required',
                'email' => 'required|email|unique:users',
                'alamat' => 'required',
            ],[
                'nama.required' => 'Nama Tidak boleh kosong',
                'alamat.required' => 'Alamat Tidak boleh kosong',
                'email.required' => 'Email Tidak boleh kosong',
                'email.email' => 'Email yang digunakan harus valid',
                'email.unique' => 'Email sudah digunakan',
            ]);
        }


        if(!empty($request->password)){
            User::where('id',Auth::user()->id)->update([
                'name' => $request->nama,
                'email' => $request->email,
                'alamat' => $request->alamat,
                'password' => Hash::make($request->password),
            ]);
        }else{
            User::where('id',Auth::user()->id)->update([
                'name' => $request->nama,
                'email' => $request->email,
                'alamat' => $request->alamat,
            ]);
        }

        return redirect('/perpus/profile/edit')->with('updateprofile','Profile Anda Berhasil diperbaharui');
    }
}
