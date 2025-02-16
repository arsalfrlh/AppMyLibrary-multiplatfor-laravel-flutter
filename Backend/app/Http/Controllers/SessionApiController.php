<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

// gunakan ini untuk api auth = php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
// untuk menggunakan api authentication menghapus tanda // pada api=>[ \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class, di file "kernel.php"
class SessionApiController extends Controller
{
    public function register(Request $request){
        //cek untuk array keynya wajib di isi
        $validator = Validator::make($request->all(),[
            'name' => 'required',
            'email' => 'required|email|unique:users',
            'alamat' => 'required',
            'password' => 'required|min:3',
        ]);

        //jika tidak di isi akan menampilkan data berikut
        if($validator->fails()){
            return response()->json(['sukses' => false, 'pesan' => 'ada kesalahan', 'data' => $validator->errors()]);
        }

        $register = [
            'name' => $request->name,
            'email' => $request->email,
            'alamat' => $request->alamat,
            'password' => Hash::make($request->password),
        ];

        $user = User::create($register);
        $login = [
            'email' => $request->email,
            'password' => $request->password,
        ];

        if(Auth::attempt($login)){
            $data = [
                'token' => $user->createToken('auth_token')->plainTextToken,
            ];
    
            return response()->json(['sukses' => true, 'pesan' => 'Berhasil Register', 'data' => $data]);
        }else{
            return response()->json(['sukses' => false, 'pesan' => 'Gagal Register', 'data' => null]);
        }
    }

    public function login(Request $request){
        //cek untuk array keynya wajib di isi
        $validator = Validator::make($request->all(),[
            'email' => 'required',
            'password' => 'required',
        ]);

        //jika tidak di isi akan menampilkan data berikut
        if($validator->fails()){
            return response()->json(['sukses' => false, 'pesan' => 'ada kesalahan', 'data' => $validator->errors()]);
        }

        $login = [
            'email' => $request->email,
            'password' => $request->password,
        ];

        if(Auth::attempt($login)){
            $data = [
                'token' => Auth::user()->createToken('auth_token')->plainTextToken,
            ];

            return response()->json(['sukses' => true, 'pesan' => 'Berhasil Login', 'data' => $data]);
        }else{
            return response()->json(['sukses' => false, 'pesan' => 'Email atau Password Salah', 'data' => null]);
        }
    }

    public function logout(Request $request){
        $request->user()->tokens()->delete();
        return response()->json(['pesan' => 'Berhasil Logout']);
    }
}
