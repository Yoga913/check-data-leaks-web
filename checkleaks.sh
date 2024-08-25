# Definisi untuk warna terminal
GREEN='\033[0;32m' # Warna hijau untuk teks
RED='\033[0;31m' # Warna merah untuk teks
NC='\033[0m'  # Tidak ada warna

# Mengecek apakah argumen yang diberikan tepat satu
if [ "$#" -ne 1 ]; then
    echo "Penggunaan: $0 <domain>" # Menampilkan pesan cara penggunaan script jika argument salah
    exit 1 # Keluar dari skript dengan setatus error
fi

# Menyimpan argument pertamam sebagai nama domain
domain=$1

# Daftar jalur (paths) yang akan dicek untuk kemungkinan kebocoran data
data_leakage_paths=(
    "/.git" "/.env" "/.htaccess" "/.htpasswd" "/.DS_Store" "/.svn" "/.gitignore"
    "/robots.txt" "/sitemap.xml" "/backup" "/dump" "/config" "/config.php"
    "/wp-config.php" "/.backup" "/.mysql_history" "/.bash_history" "/.ssh"
    "/phpinfo.php" "/info.php" "/readme.html" "/README.md" "/LICENSE"
    "/admin" "/cgi-bin" "/server-status" "/server-info" "/.dockerenv"
    "/docker-compose.yml" "/api" "/.gitlab-ci.yml" "/debug" "/cache"
    "/.user.ini" "/secret" "/.idea" "/.vscode" "/error_log" "/access_log"
    "/.mailrc" "/.forward" "/.rnd" "/.gemrc" "/.bashrc" "/.profile"
    "/.viminfo" "/.vimrc" "/.netrc" "/.ssh/authorized_keys" "/.ssh/id_rsa"
    
)

# Fungsi untuk memeriksa status HTTP dari URL
function check_path {
    local url=$1 # Mendapat URL sebagai parameter 
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url") # mengambil status kode HTTP dari URL

    # Jika status kode HTTP adalah 200 ,maka ada kemungkinanan kebocoran data
    if [ "$response" -eq 200 ]; then
        echo -e "${RED}Peringatan: Kemungkinanan kebocoran data di $url${NC}" # Menampilkan pesan peringatan (Warning: Potential data leakage at)
    else
        echo -e "${GREEN}Normal: Tidak ada kebocoran data di $url (status code: $response)${NC}" # Menampilkan pesan aman (Normal: No data leakage at)
    fi
}

# Fungsi untuk mencoba kedua protokol (HTTP dan HTTPS) untuk sebuah path
function try_both_protocols {
    local path=$1 # Mendapat kan path dari parameter
    local https_url="https://$domain$path" # Memebentuk URL dengan HTTPS
    local http_url="http://$domain$path" # Memebentuk URL dengan HTTP

    # Mengecek URL dengan protokol HTTPS terlebih dahulu
    response=$(curl -s -o /dev/null -w "%{http_code}" "$https_url")
    if [ "$response" -eq 200 ]; then
        check_path "$https_url" # Jika status kode 200, cek lebih lanjut dengan fungsi check_path
    else
        check_path "$http_url" # Jika tidak 200, coba dengan HTTP dan cek dengan fungsi check_path
    fi
}

# Loop untuk memerikasa setiap path dalam array data_leakage_paths
for path in "${data_leakage_paths[@]}"; do
    try_both_protocols "$path" # Mencoba kedua protokol untuk setiap path
done
