<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Faker\Factory as Palsu;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $palsu = Palsu::create('id_ID');
        for($i = 3; $i <= 18; $i++){
            User::create([
                'name' => $palsu->name,
                'email' => $palsu->email,
                'alamat' => $palsu->address,
                'password' => Hash::make('123'),
            ]);
        }
    }
}
