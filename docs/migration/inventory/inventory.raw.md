# macOS Machine Inventory

- **Generated:** 2026-05-05 21:53:29 BST
- **Host:** blackterminal.local
- **User:** black.terminal
- **Home:** /Users/black.terminal
- **Mode:** read-only

## 1. System

#### macOS version

`sw_vers`

```
ProductName:  macOS
ProductVersion:  26.4.1
BuildVersion:  25E253
```

#### Architecture

`uname -m`

```
x86_64
```

#### Kernel

`uname -a`

```
Darwin blackterminal.local 25.4.0 Darwin Kernel Version 25.4.0: Thu Mar 19 19:27:54 PDT 2026; root:xnu-12377.101.15~1/RELEASE_X86_64 x86_64
```

#### Hardware model

`sysctl -n hw.model 2>/dev/null`

```
MacBookPro16,1
```

#### CPU

`sysctl -n machdep.cpu.brand_string 2>/dev/null`

```
Intel(R) Core(TM) i9-9980HK CPU @ 2.40GHz
```

#### Cores (physical/logical)

`echo "physical=$(sysctl -n hw.physicalcpu) logical=$(sysctl -n hw.logicalcpu)"`

```
physical=8 logical=16
```

#### RAM

`sysctl -n hw.memsize 2>/dev/null | awk '{ printf "%.1f GB\n", $1/1024/1024/1024 }'`

```
32.0 GB
```

#### Boot time

`sysctl -n kern.boottime 2>/dev/null`

```
{ sec = 1777922353, usec = 686686 } Mon May  4 20:19:13 2026
```

#### Uptime

`uptime`

```
21:53  up 1 day,  1:34, 2 users, load averages: 2.04 2.25 2.41
```

#### Disk usage (root)

`df -h / 2>/dev/null`

```
Filesystem        Size    Used   Avail Capacity iused ifree %iused  Mounted on
/dev/disk1s1s1   400Gi    12Gi   211Gi     6%    458k  2.2G    0%   /
```

#### SIP status

`csrutil status 2>&1 || echo '(unavailable)'`

```
System Integrity Protection status: enabled.
```

#### Xcode CLT path

`xcode-select -p`

```
/Library/Developer/CommandLineTools
```

#### FileVault status

`fdesetup status 2>&1 || echo '(unavailable)'`

```
FileVault is Off.
```

## 2. Applications

### /Applications (top-level GUI apps with bundle versions)

```
Ableton Live 12 Trial                        12.3.2 (2025-12-15_bba1e05a87)
Antebot                                      1.2.0
balenaEtcher                                 2.1.4
Bose Updater                                 ?
Brave Browser                                147.1.89.145
Claude                                       1.5354.0
Codex                                        26.429.30905
CodexBar                                     0.22
CoinPoker                                    1.0.44
Cursor                                       3.3.4
Discord                                      0.0.385
flexbv                                       
Focusrite Control                            3.25.0.245
GitHub Desktop                               3.5.6
Google Chrome Dev                            149.0.7815.2
Google Docs                                  124.0
Google Drive                                 124.0
Google Sheets                                124.0
Google Slides                                124.0
GPG Keychain                                 1.12
iHosts                                       1.4.0
NordVPN                                      9.15.0
nPerf                                        2.15
OnyX                                         4.9.8
openboardview                                
PerformanceTest                              11.0.1005
Perplexity                                   2.260428.0
Prime Video                                  10.120.1
qbittorrent                                  5.0.5
RepoBar                                      0.2.0
RepoBar-0.1.1                                0.2.0
Safari                                       26.4
SoulseekQt                                   ?
SoundID Reference                            5.13.5
SoundID Reference Measure                    5.13.5
SoundID Virtual Monitoring PRO Measure       5.13.5.1215
Spotify                                      1.2.75.510
Telegram                                     12.6
The Unarchiver                               4.3.9
Tor Browser                                  15.0.11
VLC                                          3.0.21
VMware Fusion                                13.6.4
Warp                                         0.2026.04.27.15.32.03
Windsurf                                     2.1.32
```

### ~/Applications

```
Claude Code URL Handler                      ?
Gambler.Bot                                  5.0.50.0
Greptile Fix                                 ?
```

## 3. Developer CLIs and Package Managers

#### brew --version

`brew --version`

```
Homebrew 5.1.8-60-gc4e48fd
```

#### brew config

`brew config 2>/dev/null | sed -n '1,12p'`

```
HOMEBREW_VERSION: 5.1.8-60-gc4e48fd
ORIGIN: https://github.com/Homebrew/brew
HEAD: c4e48fdd080d9f892c614233c7d8166f5bb3a01e
Last commit: 3 days ago
Branch: main
Core tap JSON: 02 May 18:45 UTC
Core cask tap JSON: 02 May 18:44 UTC
HOMEBREW_PREFIX: /usr/local
HOMEBREW_AUTO_UPDATE_SECS: 86400
HOMEBREW_CASK_OPTS: []
HOMEBREW_DOWNLOAD_CONCURRENCY: 32
HOMEBREW_FORBID_PACKAGES_FROM_PATHS: set
```

#### brew taps

`brew tap`

```
dyoburon/greppy
local/codexbar
supabase/tap
```

#### brew formulae (leaves)

`brew leaves`

```
actionlint
amass
bat
cmake
duti
dyoburon/greppy/greppy
exploitdb
eza
fd
feroxbuster
ffmpeg
ffuf
fswatch
fzf
gh
git
gnu-sed
gobuster
gogcli
gradle
hashcat
hydra
iperf3
john-jumbo
jq
masscan
maven
mise
nikto
node
nuclei
nvm
pipx
pnpm
postgresql@16
pyenv-virtualenv
python@3.13
redis
ripgrep
ruby
ruff
rustscan
sevenzip
sqlmap
starship
subfinder
supabase/tap/supabase
tesseract
tmux
uv
watchman
wget
yt-dlp
zoxide
```

#### brew formulae (all)

`brew list --formula --versions`

```
actionlint 1.7.12
ada-url 3.4.4
amass 5.1.1
autoconf 2.73
bat 0.26.1
boost 1.90.0_1
brotli 1.2.0
c-ares 1.34.6
ca-certificates 2026-03-19
cairo 1.18.4
certifi 2026.4.22
cmake 4.3.2
coreutils 9.11
dav1d 1.5.3
deno 2.7.14
double-conversion 3.4.0
duti 1.5.4_1
edencommon 2026.04.27.00
exploitdb 2026-05-01
eza 0.23.4
fb303 2026.04.27.00
fbthrift 2026.04.27.00
fd 10.4.2
feroxbuster 2.13.1
ffmpeg 8.1_1
ffuf 2.1.0
fizz 2026.04.27.00
fmt 12.1.0
folly 2026.04.27.00
fontconfig 2.17.1
freetype 2.14.3
fribidi 1.0.16
fswatch 1.20.1
fzf 0.72.0
gettext 1.0
gflags 2.3.0
gh 2.92.0
giflib 6.1.3
git 2.54.0
glib 2.88.0
glog 0.7.1
gmp 6.3.0
gnu-sed 4.10
gobuster 3.8.2
gogcli 0.14.0
gradle 9.5.0
gradle-completion 9.5.0
graphite2 1.3.14
greppy 0.5.5
harfbuzz 14.2.0
hashcat 7.1.2
hdrhistogram_c 0.11.9
hydra 9.6
icu4c@78 78.3
iperf3 3.21_1
john-jumbo 1.9.0_1
jpeg-turbo 3.1.4.1
jq 1.8.1
krb5 1.22.2
lame 3.100
leptonica 1.87.0
libarchive 3.8.7
libb2 0.98.1
libdatrie 0.2.14
libevent 2.1.12_1
libgit2 1.9.2_2
libidn2 2.3.8
liblinear 2.50
libnghttp2 1.69.0
libnghttp3 1.15.0
libngtcp2 1.22.1
libpng 1.6.58
libsodium 1.0.22
libssh 0.12.0_1
libssh2 1.11.1_1
libthai 0.1.30
libtiff 4.7.1_1
libunistring 1.4.2
libuv 1.52.1
libvmaf 3.1.0
libvpx 1.16.0
libx11 1.8.13
libxau 1.0.12
libxcb 1.17.0
libxdmcp 1.1.5
libxext 1.3.7
libxrender 0.9.12
libyaml 0.2.5
little-cms2 2.19
llhttp 9.4.1
lua 5.5.0
lz4 1.10.0
lzo 2.10
m4 1.4.21
mariadb-connector-c 3.4.8_1
masscan 1.3.2
maven 3.9.15
merve 1.2.2_1
minizip 1.3.2_1
mise 2026.4.28
mpdecimal 4.0.1
nbytes 0.1.4
ncurses 6.6
nikto 2.6.0
nmap 7.99
node 25.9.0_3
nuclei 3.8.0
nvm 0.40.4
oniguruma 6.9.10
openjdk 25.0.2
openjpeg 2.5.4
openssl@3 3.6.2
openssl@4 4.0.0
opus 1.6.1
pango 1.57.1
pcre2 10.47_1
pipx 1.11.1
pixman 0.46.4
pkgconf 2.5.1
pnpm 10.33.0
postgresql@16 16.13
pyenv 2.6.28
pyenv-virtualenv 1.4.0
python@3.12 3.12.13_2
python@3.13 3.13.13_1
python@3.14 3.14.4_1
readline 8.3.3
redis 8.6.2
ripgrep 15.1.0
ruby 4.0.3
ruff 0.15.12
rustscan 2.4.1
sdl2 2.32.10
sevenzip 26.01
shellcheck 0.11.0
simdjson 4.6.3
simdutf 9.0.0
snappy 1.2.2
sqlite 3.53.0
sqlmap 1.10.5
starship 1.25.1
subfinder 2.14.0
supabase 2.95.4
svt-av1 4.1.0
tesseract 5.5.2
tmux 3.6a
usage 3.2.1
utf8proc 2.11.3
uv 0.11.8
uvwasi 0.0.23
wangle 2026.04.27.00
watchman 2026.04.27.00
webp 1.6.0
wget 1.25.0
x264 r3222
x265 4.2
xorgproto 2025.1
xxhash 0.8.3
xz 5.8.3
yt-dlp 2026.3.17_1
zoxide 0.9.9
zstd 1.5.7_1
```

#### brew casks

`brew list --cask --versions`

```
codexbar-intel 0.19.0
docker-desktop 4.59.1,217750
dotnet-sdk 10.0.201
font-hack-nerd-font 3.4.0
font-meslo-lg-nerd-font 3.4.0
iterm2 3.6.6
metasploit 6.4.124,20260324055545
repobar 0.2.0
warp 0.2026.01.21.08.14.stable_01
```

#### npm

`echo "version=$(npm --version)"; echo; echo 'globals:'; npm list -g --depth=0 2>/dev/null`

```
version=10.9.4

globals:
/Users/black.terminal/.nvm/versions/node/v22.22.0/lib
├── @continuedev/cli@1.5.45
├── @openai/codex@0.128.0
├── @steipete/poltergeist@2.1.1
├── @steipete/summarize@0.14.1
├── @withone/cli@1.42.0
├── corepack@0.34.7
├── dev-browser@0.2.7
├── firecrawl-cli@1.16.0
├── greptile@2.4.0
├── iterm-mcp@1.2.6
├── npm@10.9.4
├── opencode-ai@1.14.32
└── repomix@1.14.0
```

#### pnpm

`echo "version=$(command pnpm --version)"; echo; echo 'globals:'; command pnpm list -g --depth=0 2>/dev/null`

```
version=10.33.0

globals:
```

#### yarn

`echo "version=$(yarn --version)"; echo; echo 'globals:'; yarn global list --depth=0 2>/dev/null`

```
version=1.22.22

globals:
yarn global v1.22.22
Done in 0.02s.
```

#### pip

`pip --version; echo; pip list 2>/dev/null`

```
pip 26.0.1 from /Users/black.terminal/.pyenv/versions/3.13.12/lib/python3.13/site-packages/pip (python 3.13)

Package                                  Version     Editable project location
---------------------------------------- ----------- ------------------------------------------------------------------------------------------------------------------------
agent-client-protocol                    0.8.1
aiofiles                                 25.1.0
aiohappyeyeballs                         2.6.1
aiohttp                                  3.13.3
aiosignal                                1.4.0
aiosqlite                                0.22.1
annotated-doc                            0.0.4
annotated-types                          0.7.0
anthropic                                0.86.0
anyio                                    4.12.1
attrs                                    25.4.0
beautifulsoup4                           4.14.3
blockbuster                              1.5.26
bracex                                   2.6
bsela                                    0.0.1       /Users/black.terminal/Projects/Current/Active/BEST-Self-Enhancement-Learning-AI/.claude/worktrees/elegant-haslett-b815ef
certifi                                  2026.2.25
cffi                                     2.0.0
charset-normalizer                       3.4.6
click                                    8.3.1
cloudpickle                              3.1.2
croniter                                 6.2.2
cryptography                             46.0.5
deepagents                               0.5.0       /Users/black.terminal/Projects/Current/Active/deepagents/libs/deepagents
defusedxml                               0.7.1
distro                                   1.9.0
docstring_parser                         0.17.0
filetype                                 1.2.0
fonttools                                4.61.1
forbiddenfruit                           0.1.4
fpdf2                                    2.8.5
frozenlist                               1.8.0
google-auth                              2.49.1
google-genai                             1.68.0
googleapis-common-protos                 1.73.0
greenlet                                 3.4.0
grpcio                                   1.78.0
grpcio-health-checking                   1.78.0
grpcio-tools                             1.78.0
h11                                      0.16.0
httpcore                                 1.0.9
httpx                                    0.28.1
httpx-sse                                0.4.3
idna                                     3.11
importlib_metadata                       8.7.1
jiter                                    0.13.0
jsonpatch                                1.33
jsonpointer                              3.0.0
jsonschema                               4.26.0
jsonschema_rs                            0.44.1
jsonschema-specifications                2025.9.1
langchain                                1.2.13
langchain-anthropic                      1.4.0
langchain-core                           1.2.20
langchain-google-genai                   4.2.1
langchain-mcp-adapters                   0.2.2
langchain-ollama                         1.0.1
langchain-openai                         1.1.11
langgraph                                1.1.3
langgraph-api                            0.7.83
langgraph-checkpoint                     4.0.1
langgraph-checkpoint-sqlite              3.0.3
langgraph-cli                            0.4.19
langgraph-prebuilt                       1.0.8
langgraph-runtime-inmem                  0.26.0
langgraph-sdk                            0.3.12
langsmith                                0.7.22
linkify-it-py                            2.1.0
markdown-it-py                           4.0.0
markdownify                              1.2.2
mcp                                      1.26.0
mdit-py-plugins                          0.5.0
mdurl                                    0.1.2
multidict                                6.7.1
ollama                                   0.6.1
openai                                   2.29.0
opentelemetry-api                        1.40.0
opentelemetry-exporter-otlp-proto-common 1.40.0
opentelemetry-exporter-otlp-proto-http   1.40.0
opentelemetry-proto                      1.40.0
opentelemetry-sdk                        1.40.0
opentelemetry-semantic-conventions       0.61b0
orjson                                   3.11.7
ormsgpack                                1.12.2
packaging                                26.0
pillow                                   12.1.1
pip                                      26.0.1
platformdirs                             4.9.4
prompt_toolkit                           3.0.52
propcache                                0.4.1
protobuf                                 6.33.6
pyaes                                    1.6.1
pyasn1                                   0.6.2
pyasn1_modules                           0.4.2
pycparser                                3.0
pydantic                                 2.12.5
pydantic_core                            2.41.5
pydantic-settings                        2.13.1
Pygments                                 2.19.2
PyJWT                                    2.12.1
pyperclip                                1.11.0
python-dateutil                          2.9.0.post0
python-dotenv                            1.2.1
python-multipart                         0.0.22
PyYAML                                   6.0.3
referencing                              0.37.0
regex                                    2026.2.28
requests                                 2.32.5
requests-toolbelt                        1.0.0
rich                                     14.3.3
rpds-py                                  0.30.0
rsa                                      4.9.1
setuptools                               82.0.1
shellingham                              1.5.4
six                                      1.17.0
sniffio                                  1.3.1
soupsieve                                2.8.3
SQLAlchemy                               2.0.49
sqlite-vec                               0.1.7
sqlmodel                                 0.0.38
sse-starlette                            3.3.3
starlette                                0.52.1
structlog                                25.5.0
tavily-python                            0.7.23
Telethon                                 1.42.0
tenacity                                 9.1.4
textual                                  8.1.1
textual-autocomplete                     4.0.6
textual-speedups                         0.2.1
tiktoken                                 0.12.0
tomli_w                                  1.2.0
tqdm                                     4.67.3
truststore                               0.10.4
typer                                    0.25.0
typing_extensions                        4.15.0
typing-inspection                        0.4.2
uc-micro-py                              2.0.0
urllib3                                  2.6.3
uuid_utils                               0.14.1
uvicorn                                  0.42.0
vt-py                                    0.22.0
watchfiles                               1.1.1
wcmatch                                  10.1
wcwidth                                  0.6.0
websockets                               16.0
wheel                                    0.46.3
xxhash                                   3.6.0
yarl                                     1.22.0
zipp                                     3.23.0
zstandard                                0.25.0
```

#### pip3

`pip3 --version; echo; pip3 list 2>/dev/null`

```
pip 26.0.1 from /Users/black.terminal/.pyenv/versions/3.13.12/lib/python3.13/site-packages/pip (python 3.13)

Package                                  Version     Editable project location
---------------------------------------- ----------- ------------------------------------------------------------------------------------------------------------------------
agent-client-protocol                    0.8.1
aiofiles                                 25.1.0
aiohappyeyeballs                         2.6.1
aiohttp                                  3.13.3
aiosignal                                1.4.0
aiosqlite                                0.22.1
annotated-doc                            0.0.4
annotated-types                          0.7.0
anthropic                                0.86.0
anyio                                    4.12.1
attrs                                    25.4.0
beautifulsoup4                           4.14.3
blockbuster                              1.5.26
bracex                                   2.6
bsela                                    0.0.1       /Users/black.terminal/Projects/Current/Active/BEST-Self-Enhancement-Learning-AI/.claude/worktrees/elegant-haslett-b815ef
certifi                                  2026.2.25
cffi                                     2.0.0
charset-normalizer                       3.4.6
click                                    8.3.1
cloudpickle                              3.1.2
croniter                                 6.2.2
cryptography                             46.0.5
deepagents                               0.5.0       /Users/black.terminal/Projects/Current/Active/deepagents/libs/deepagents
defusedxml                               0.7.1
distro                                   1.9.0
docstring_parser                         0.17.0
filetype                                 1.2.0
fonttools                                4.61.1
forbiddenfruit                           0.1.4
fpdf2                                    2.8.5
frozenlist                               1.8.0
google-auth                              2.49.1
google-genai                             1.68.0
googleapis-common-protos                 1.73.0
greenlet                                 3.4.0
grpcio                                   1.78.0
grpcio-health-checking                   1.78.0
grpcio-tools                             1.78.0
h11                                      0.16.0
httpcore                                 1.0.9
httpx                                    0.28.1
httpx-sse                                0.4.3
idna                                     3.11
importlib_metadata                       8.7.1
jiter                                    0.13.0
jsonpatch                                1.33
jsonpointer                              3.0.0
jsonschema                               4.26.0
jsonschema_rs                            0.44.1
jsonschema-specifications                2025.9.1
langchain                                1.2.13
langchain-anthropic                      1.4.0
langchain-core                           1.2.20
langchain-google-genai                   4.2.1
langchain-mcp-adapters                   0.2.2
langchain-ollama                         1.0.1
langchain-openai                         1.1.11
langgraph                                1.1.3
langgraph-api                            0.7.83
langgraph-checkpoint                     4.0.1
langgraph-checkpoint-sqlite              3.0.3
langgraph-cli                            0.4.19
langgraph-prebuilt                       1.0.8
langgraph-runtime-inmem                  0.26.0
langgraph-sdk                            0.3.12
langsmith                                0.7.22
linkify-it-py                            2.1.0
markdown-it-py                           4.0.0
markdownify                              1.2.2
mcp                                      1.26.0
mdit-py-plugins                          0.5.0
mdurl                                    0.1.2
multidict                                6.7.1
ollama                                   0.6.1
openai                                   2.29.0
opentelemetry-api                        1.40.0
opentelemetry-exporter-otlp-proto-common 1.40.0
opentelemetry-exporter-otlp-proto-http   1.40.0
opentelemetry-proto                      1.40.0
opentelemetry-sdk                        1.40.0
opentelemetry-semantic-conventions       0.61b0
orjson                                   3.11.7
ormsgpack                                1.12.2
packaging                                26.0
pillow                                   12.1.1
pip                                      26.0.1
platformdirs                             4.9.4
prompt_toolkit                           3.0.52
propcache                                0.4.1
protobuf                                 6.33.6
pyaes                                    1.6.1
pyasn1                                   0.6.2
pyasn1_modules                           0.4.2
pycparser                                3.0
pydantic                                 2.12.5
pydantic_core                            2.41.5
pydantic-settings                        2.13.1
Pygments                                 2.19.2
PyJWT                                    2.12.1
pyperclip                                1.11.0
python-dateutil                          2.9.0.post0
python-dotenv                            1.2.1
python-multipart                         0.0.22
PyYAML                                   6.0.3
referencing                              0.37.0
regex                                    2026.2.28
requests                                 2.32.5
requests-toolbelt                        1.0.0
rich                                     14.3.3
rpds-py                                  0.30.0
rsa                                      4.9.1
setuptools                               82.0.1
shellingham                              1.5.4
six                                      1.17.0
sniffio                                  1.3.1
soupsieve                                2.8.3
SQLAlchemy                               2.0.49
sqlite-vec                               0.1.7
sqlmodel                                 0.0.38
sse-starlette                            3.3.3
starlette                                0.52.1
structlog                                25.5.0
tavily-python                            0.7.23
Telethon                                 1.42.0
tenacity                                 9.1.4
textual                                  8.1.1
textual-autocomplete                     4.0.6
textual-speedups                         0.2.1
tiktoken                                 0.12.0
tomli_w                                  1.2.0
tqdm                                     4.67.3
truststore                               0.10.4
typer                                    0.25.0
typing_extensions                        4.15.0
typing-inspection                        0.4.2
uc-micro-py                              2.0.0
urllib3                                  2.6.3
uuid_utils                               0.14.1
uvicorn                                  0.42.0
vt-py                                    0.22.0
watchfiles                               1.1.1
wcmatch                                  10.1
wcwidth                                  0.6.0
websockets                               16.0
wheel                                    0.46.3
xxhash                                   3.6.0
yarl                                     1.22.0
zipp                                     3.23.0
zstandard                                0.25.0
```

#### uv

`uv --version; echo; uv tool list 2>/dev/null`

```
uv 0.11.8 (Homebrew 2026-04-27 x86_64-apple-darwin)

bsela v0.0.1
- bsela
```

#### pipx

`pipx --version 2>/dev/null; echo; pipx list 2>/dev/null`

```
1.11.1

venvs are in /Users/black.terminal/.local/pipx/venvs
apps are exposed on your $PATH at /Users/black.terminal/.local/bin
manual pages are exposed at /Users/black.terminal/.local/share/man
   package pre-commit 4.5.1, installed using Python 3.14.3
    - pre-commit
```

#### gem

`gem --version; echo; gem list --local 2>/dev/null | head -200`

```
3.0.3.1

bigdecimal (default: 1.4.1)
bundler (default: 1.17.2)
CFPropertyList (2.3.6)
cmath (default: 1.0.0)
csv (default: 3.0.9)
date (default: 2.0.3)
dbm (default: 1.0.0)
did_you_mean (1.3.0)
e2mmap (default: 0.1.0)
etc (default: 1.0.1)
fcntl (default: 1.0.0)
fiddle (default: 1.0.0)
fileutils (default: 1.1.0)
forwardable (default: 1.2.0)
io-console (default: 0.4.7)
ipaddr (default: 1.2.2)
irb (default: 1.0.0)
json (default: 2.1.0)
libxml-ruby (3.2.1)
logger (default: 1.3.0)
matrix (default: 0.1.0)
mini_portile2 (2.8.0)
minitest (5.11.3)
mutex_m (default: 0.1.0)
net-telnet (0.2.0)
nokogiri (1.13.8)
openssl (default: 2.1.2)
ostruct (default: 0.1.0)
power_assert (1.1.3)
prime (default: 0.1.0)
psych (default: 3.1.0)
rake (12.3.3)
rdoc (default: 6.1.2.1)
rexml (default: 3.4.2)
rss (default: 0.2.7)
scanf (default: 1.0.0)
sdbm (default: 1.0.0)
shell (default: 0.7)
sqlite3 (1.3.13)
stringio (default: 0.0.2)
strscan (default: 1.0.0)
sync (default: 0.5.0)
test-unit (3.2.9)
thwait (default: 0.1.0)
tracer (default: 0.1.0)
webrick (default: 1.9.1)
xmlrpc (0.3.0)
zlib (default: 1.0.0)
```

## 4. Runtimes

#### node

`node --version; echo path=$(command -v node)`

```
v22.22.0
path=/Users/black.terminal/.nvm/versions/node/v22.22.0/bin/node
```

#### python

`python --version; echo path=$(command -v python)`

```
Python 3.13.12
path=/Users/black.terminal/.pyenv/shims/python
```

#### python3

`python3 --version; echo path=$(command -v python3)`

```
Python 3.13.12
path=/Users/black.terminal/.pyenv/shims/python3
```

#### ruby

`ruby --version; echo path=$(command -v ruby)`

```
ruby 2.6.10p210 (2022-04-12 revision 67958) [universal.x86_64-darwin25]
path=/usr/bin/ruby
```

#### java

`java -version 2>&1 | head -3; echo path=$(command -v java)`

```
java version "24.0.2" 2025-07-15
Java(TM) SE Runtime Environment (build 24.0.2+12-54)
Java HotSpot(TM) 64-Bit Server VM (build 24.0.2+12-54, mixed mode, sharing)
path=/usr/bin/java
```

#### deno

`deno --version; echo path=$(command -v deno)`

```
deno 2.7.14 (stable, release, x86_64-apple-darwin)
v8 14.7.173.20-rusty
typescript 5.9.2
path=/usr/local/bin/deno
```

#### perl

`perl -v | sed -n '2p'; echo path=$(command -v perl)`

```
This is perl 5, version 34, subversion 1 (v5.34.1) built for darwin-thread-multi-2level
path=/usr/bin/perl
```

#### lua

`lua -v 2>&1 | head -1; echo path=$(command -v lua)`

```
Lua 5.5.0  Copyright (C) 1994-2025 Lua.org, PUC-Rio
path=/usr/local/bin/lua
```

#### pyenv

`echo version=$(pyenv --version); echo; pyenv versions`

```
version=pyenv 2.6.28

  system
  3.11.9
  3.12.11
* 3.13.12 (set by /Users/black.terminal/.pyenv/version)
```

### nvm (~/.nvm)

#### nvm node versions

`ls /Users/black.terminal/.nvm/versions/node 2>/dev/null`

```
v22.22.0
```

## 5. Services / Infra

#### brew services

`brew services list 2>/dev/null`

```
Name          Status User           File
postgresql@16 started         black.terminal ~/Library/LaunchAgents/homebrew.mxcl.postgresql@16.plist
redis         started         black.terminal ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
```

#### redis-cli

`redis-cli --version; redis-cli ping 2>&1 || true`

```
redis-cli 8.6.2
PONG
```

#### sqlite3

`sqlite3 --version`

```
3.51.0 2025-06-12 13:14:41 f0ca7bba1c5e232e5d279fad6338121ab55af0c8c68c84cdfb18ba5114dcaapl (64-bit)
```

#### supabase CLI

`supabase --version 2>/dev/null`

```
2.95.4
```

## 6. Shell and Terminal

#### Default shell

`echo "$SHELL"; $SHELL --version 2>&1 | head -1`

```
/bin/zsh
zsh 5.9 (x86_64-apple-darwin25.0)
```

#### TERM_PROGRAM

`echo "${TERM_PROGRAM:-unknown}"`

```
Apple_Terminal
```

### Shell config files

- `~/.zshrc` (583 lines)
- `~/.zshenv` (2 lines)
- `~/.zprofile` (9 lines)
- `~/.bashrc` (35 lines)
- `~/.bash_profile` (38 lines)

### Prompt frameworks / shell tooling

- oh-my-zsh: present
- powerlevel10k config: present
- starship: present

### Terminal apps installed

- Terminal: installed
- Warp: installed

## 7. Coding Tools

### Editors / IDEs (presence in /Applications)

- Cursor: 3.3.4
- Windsurf: 2.1.32

### Editor CLI launchers + extensions

- `code` -> /usr/local/bin/code — 3.3.4
- `windsurf` -> /usr/local/bin/windsurf — 1.110.1

#### code extensions

`code --list-extensions --show-versions 2>/dev/null`

```
anthropic.claude-code@2.1.128
anysphere.cursorpyright@1.0.10
anysphere.remote-ssh@1.0.48
bradlc.vscode-tailwindcss@0.14.28
christian-kohler.npm-intellisense@1.4.5
christian-kohler.path-intellisense@2.8.0
davidanson.vscode-markdownlint@0.61.2
dbaeumer.vscode-eslint@3.0.24
eamodio.gitlens@17.12.2
esbenp.prettier-vscode@12.4.0
formulahendry.auto-rename-tag@0.1.10
github.vscode-github-actions@0.31.5
github.vscode-pull-request-github@0.120.2
mikestead.dotenv@1.0.1
ms-playwright.playwright@1.1.19
ms-python.debugpy@2026.6.0
ms-python.python@2025.6.1
pkief.material-icon-theme@5.34.0
prisma.prisma@31.10.0
yoavbls.pretty-ts-errors@0.8.7
zhuangtongfa.material-theme@3.19.0
```

#### windsurf extensions

`windsurf --list-extensions --show-versions 2>/dev/null`

```
anthropic.claude-code@2.1.89
bradlc.vscode-tailwindcss@0.14.28
christian-kohler.npm-intellisense@1.4.5
christian-kohler.path-intellisense@2.8.0
codeium.windsurfpyright@1.29.5
davidanson.vscode-markdownlint@0.61.2
dbaeumer.vscode-eslint@3.0.24
eamodio.gitlens@17.12.2
esbenp.prettier-vscode@12.4.0
formulahendry.auto-rename-tag@0.1.10
github.vscode-github-actions@0.31.5
github.vscode-pull-request-github@0.140.0
mikestead.dotenv@1.0.1
ms-playwright.playwright@1.1.19
ms-python.debugpy@2026.6.0
ms-python.python@2026.4.0
openai.chatgpt@26.5422.30944
pkief.material-icon-theme@5.34.0
prisma.prisma@31.10.0
redhat.java@1.54.0
vscjava.vscode-gradle@3.17.3
vscjava.vscode-java-debug@0.59.0
vscjava.vscode-java-dependency@0.27.2
vscjava.vscode-java-pack@0.30.5
vscjava.vscode-java-test@0.45.0
vscjava.vscode-maven@0.45.3
yoavbls.pretty-ts-errors@0.8.7
zhuangtongfa.material-theme@3.19.0
```

### Common CLI tools

- git                  /usr/local/bin/git — git version 2.54.0
- gh                   /usr/local/bin/gh — gh version 2.92.0 (2026-04-28)
- claude               /Users/black.terminal/.local/bin/claude — 2.1.128 (Claude Code)
- codex                /Users/black.terminal/.nvm/versions/node/v22.22.0/bin/codex — codex-cli 0.128.0
- jq                   /usr/local/bin/jq — jq-1.8.1
- fzf                  /usr/local/bin/fzf — 0.72.0 (Homebrew)
- rg                   /usr/local/bin/rg — ripgrep 15.1.0
- fd                   /usr/local/bin/fd — fd 10.4.2
- bat                  /usr/local/bin/bat — bat 0.26.1
- eza                  /usr/local/bin/eza — eza - A modern, maintained replacement for ls
- zoxide               /usr/local/bin/zoxide — zoxide 0.9.9
- tmux                 /usr/local/bin/tmux — tmux 3.6a
- screen               /usr/bin/screen — Screen version 4.00.03 (FAU) 23-Oct-06
- make                 /usr/bin/make — GNU Make 3.81
- cmake                /usr/local/bin/cmake — cmake version 4.3.2
- pkg-config           /usr/local/bin/pkg-config — 2.5.1
- mise                 /usr/local/bin/mise — 2026.4.28 macos-x64 (2026-04-30)
- vim                  /usr/bin/vim — VIM - Vi IMproved 9.1 (2024 Jan 02, compiled Feb 21 2026 19:49:09)
- nano                 /usr/bin/nano — [?1049h[1;24r[1;1H[J[7m  UW PICO 5.09                           New Buffer                             [27m[23;1H[K[24;1H[K[23;1H[7m^[27m[7mG[27m Get Help  [7m^[27m[7mO[27m WriteOut  [7m^[27m[7mR[27m Read File [7m^[27m[7mY[27m Prev Pg   [7m^[27m[7mK[27m Cut Text  [7m^[27m[7mC[27m Cur Pos   [K[24;1H[7m^[27m[7mX[27m Exit      [7m^[27m[7mJ[27m Justify   [7m^[27m[7mW[27m Where is  [7m^[27m[7mV[27m Next Pg   [7m^[27m[7mU[27m UnCut Text[7m^[27m[7mT[27m To Spell  [K[3;1H[1;1H[J[7m  UW PICO 5.09                           New Buffer                             [27m[23;1H[K[24;1H[K[23;1H[7m^[27m[7mG[27m Get Help  [7m^[27m[7mO[27m WriteOut  [7m^[27m[7mR[27m Read File [7m^[27m[7mY[27m Prev Pg   [7m^[27m[7mK[27m Cut Text  [7m^[27m[7mC[27m Cur Pos   [K[24;1H[7m^[27m[7mX[27m Exit      [7m^[27m[7mJ[27m Justify   [7m^[27m[7mW[27m Where is  [7m^[27m[7mV[27m Next Pg   [7m^[27m[7mU[27m UnCut Text[7m^[27m[7mT[27m To Spell  [K[3;1H[23;1H[K[24;1H[K[?1049l
- vercel               /usr/local/bin/vercel — 50.22.1
- wget                 /usr/local/bin/wget — GNU Wget 1.25.0 built on darwin23.6.0.
- curl                 /usr/bin/curl — curl 8.7.1 (x86_64-apple-darwin25.0) libcurl/8.7.1 (SecureTransport) LibreSSL/3.3.6 zlib/1.2.12 nghttp2/1.68.0
- openssl              /usr/local/bin/openssl — OpenSSL 3.6.2 7 Apr 2026 (Library: OpenSSL 3.6.2 7 Apr 2026)
- gpg                  /usr/local/bin/gpg — gpg (GnuPG/MacGPG2) 2.2.41
- ssh-keygen           /usr/bin/ssh-keygen — ?
- ffmpeg               /usr/local/bin/ffmpeg — ?
- tesseract            /usr/local/bin/tesseract — tesseract 5.5.2
- yt-dlp               /usr/local/bin/yt-dlp — 2026.03.17
- rsync                /usr/bin/rsync — openrsync: protocol version 29
- lsof                 /usr/sbin/lsof — COMMAND     PID           USER   FD      TYPE             DEVICE  SIZE/OFF                NODE NAME
- fswatch              /usr/local/bin/fswatch — fswatch 1.20.1

## 8. AI Ecosystem Footprint

### Claude Code — `/Users/black.terminal/.claude`

```
total 264
drwx------   31 black.terminal  staff    992 May  5 21:17 .
drwxr-x---+ 138 black.terminal  staff   4416 May  5 21:20 ..
-rw-r--r--@   1 black.terminal  staff  10244 May  5 21:14 .DS_Store
drwxr-xr-x    6 black.terminal  staff    192 Apr 26 18:36 agents
drwxr-xr-x   12 black.terminal  staff    384 May  5 21:20 backups
-rw-r--r--@   1 black.terminal  staff    820 Apr 15 14:39 bash-log.txt
drwxr-xr-x@   4 black.terminal  staff    128 Apr 23 06:43 cache
-rw-r--r--@   1 black.terminal  staff    746 May  4 21:41 CLAUDE.md
drwxr-xr-x@   2 black.terminal  staff     64 Apr 26 18:30 commands
drwxr-xr-x    4 black.terminal  staff    128 Apr 26 13:47 debug
drwxr-xr-x    2 black.terminal  staff     64 Apr 23 01:24 downloads
drwxr-xr-x   39 black.terminal  staff   1248 May  5 21:20 file-history
-rw-------@   1 black.terminal  staff  66472 May  5 21:17 history.jsonl
drwx------    2 black.terminal  staff     64 May  5 21:14 ide
-rw-r--r--@   1 black.terminal  staff     88 May  5 21:22 mcp-needs-auth-cache.json
drwxr-xr-x@  18 black.terminal  staff    576 May  5 21:12 paste-cache
drwxr-xr-x   10 black.terminal  staff    320 Apr 26 15:59 plans
drwxr-xr-x    3 black.terminal  staff     96 Apr 24 03:06 plugins
-rw-------@   1 black.terminal  staff    219 May  2 20:10 policy-limits.json
drwxr-xr-x   13 black.terminal  staff    416 May  4 22:10 projects
drwxr-xr-x   10 black.terminal  staff    320 Apr 19 18:18 rules
drwxr-xr-x  203 black.terminal  staff   6496 May  5 20:31 session-env
drwx------@   3 black.terminal  staff     96 May  5 20:31 sessions
-rw-r--r--@   1 black.terminal  staff  25713 May  5 20:31 sessions.log
-rw-r--r--@   1 black.terminal  staff   3406 May  5 20:54 settings.json
-rw-r--r--@   1 black.terminal  staff   2335 May  4 23:43 settings.local.json
drwxr-xr-x@   3 black.terminal  staff     96 May  5 21:14 shell-snapshots
drwxr-xr-x   33 black.terminal  staff   1056 May  5 21:15 skills
drwxr-xr-x    6 black.terminal  staff    192 May  4 22:10 tasks
drwxr-xr-x@   9 black.terminal  staff    288 May  4 20:05 telemetry
drwxr-xr-x    3 black.terminal  staff     96 May  2 19:05 vendor
```

**Notable subpaths:**

- `/Users/black.terminal/.claude/CLAUDE.md` (746 bytes)
- `/Users/black.terminal/.claude/settings.json` (3406 bytes)
- `/Users/black.terminal/.claude/settings.local.json` (2335 bytes)
- `/Users/black.terminal/.claude/rules/` (8 entries)
- `/Users/black.terminal/.claude/skills/` (30 entries)
- `/Users/black.terminal/.claude/agents/` (4 entries)
- `/Users/black.terminal/.claude/commands/` (0 entries)
- `/Users/black.terminal/.claude/plugins/` (1 entries)
- `/Users/black.terminal/.claude/projects/` (10 entries)
- `/Users/black.terminal/.claude/sessions/` (1 entries)

### Cursor — `/Users/black.terminal/.cursor`

```
total 88
drwxr-xr-x   23 black.terminal  staff   736 May  3 11:12 .
drwxr-x---+ 138 black.terminal  staff  4416 May  5 21:20 ..
-rw-r--r--@   1 black.terminal  staff  6148 May  3 01:40 .DS_Store
-rw-r--r--    1 black.terminal  staff  1190 May  5 20:15 .gitignore
drwxr-xr-x    6 black.terminal  staff   192 May  2 21:22 .ruff_cache
drwxr-xr-x   15 black.terminal  staff   480 May  5 00:33 agents
drwxr-xr-x    6 black.terminal  staff   192 May  5 20:05 ai-tracking
-rw-r--r--    1 black.terminal  staff   798 Apr 12 23:02 argv.json
-rw-r--r--    1 black.terminal  staff   588 May  4 21:41 cli-config.json
drwxr-xr-x    2 black.terminal  staff    64 Apr 18 16:13 debug-logs
drwxr-xr-x   26 black.terminal  staff   832 May  5 09:42 extensions
drwxr-xr-x    8 black.terminal  staff   256 Apr 22 00:12 hooks
-rw-r--r--    1 black.terminal  staff   578 May  4 21:41 hooks.json
-rw-r--r--    1 black.terminal  staff  1515 May  3 11:13 ide_state.json
-rw-------@   1 black.terminal  staff  1123 Apr 21 01:30 mcp.json
drwxr-xr-x   20 black.terminal  staff   640 May  5 00:32 plans
drwxr-xr-x    4 black.terminal  staff   128 May  2 19:05 plugins
drwxr-xr-x   42 black.terminal  staff  1344 May  3 12:21 projects
-rw-r--r--    1 black.terminal  staff  4453 May  4 21:41 README.md
drwxr-xr-x   14 black.terminal  staff   448 Apr 22 00:07 rules
drwxr-xr-x    9 black.terminal  staff   288 May  5 19:19 skills
drwxr-xr-x   16 black.terminal  staff   512 May  5 21:45 skills-cursor
-rwxr-xr-x    1 black.terminal  staff  1241 May  4 21:41 statusline.sh
```

**Notable subpaths:**

- `/Users/black.terminal/.cursor/mcp.json` (1123 bytes)
- `/Users/black.terminal/.cursor/rules/` (12 entries)
- `/Users/black.terminal/.cursor/skills/` (7 entries)
- `/Users/black.terminal/.cursor/hooks/` (6 entries)
- `/Users/black.terminal/.cursor/agents/` (13 entries)
- `/Users/black.terminal/.cursor/plugins/` (2 entries)
- `/Users/black.terminal/.cursor/extensions/` (23 entries)
- `/Users/black.terminal/.cursor/projects/` (40 entries)

### Codex CLI — `/Users/black.terminal/.codex`

```
total 120896
drwxr-xr-x@  38 black.terminal  staff      1216 May  5 21:12 .
drwxr-x---+ 138 black.terminal  staff      4416 May  5 21:20 ..
-rw-r--r--    1 black.terminal  staff     13764 May  3 08:21 .codex-global-state.json
-rw-r--r--    1 black.terminal  staff     13764 May  3 08:21 .codex-global-state.json.bak
-rw-r--r--@   1 black.terminal  staff     10244 May  5 21:14 .DS_Store
-rw-r--r--    1 black.terminal  staff         3 Feb 17 23:00 .personality_migration
drwxr-xr-x   11 black.terminal  staff       352 May  5 20:48 .tmp
-rw-r--r--@   1 black.terminal  staff     12698 May  3 11:20 AGENTS.md
drwxr-xr-x@   9 black.terminal  staff       288 Apr 26 20:12 archived_sessions
-rw-------@   1 black.terminal  staff      4173 May  1 08:57 auth.json
drwxr-xr-x@   3 black.terminal  staff        96 May  2 19:05 backups
drwxr-xr-x    3 black.terminal  staff        96 Apr 25 00:22 browser
drwxr-xr-x    3 black.terminal  staff        96 Mar 10 22:55 cache
-rw-------@   1 black.terminal  staff      4013 May  4 21:41 config.toml
-rw-------@   1 black.terminal  staff     43666 May  2 21:51 history.jsonl
drwxr-xr-x    7 black.terminal  staff       224 Apr 23 23:38 hooks
-rw-r--r--@   1 black.terminal  staff        36 Apr 18 19:02 installation_id
drwxr-xr-x@   3 black.terminal  staff        96 Mar 21 10:19 log
-rw-r--r--@   1 black.terminal  staff  55975936 May  5 21:50 logs_2.sqlite
-rw-r--r--@   1 black.terminal  staff     32768 May  5 21:50 logs_2.sqlite-shm
-rw-r--r--@   1 black.terminal  staff         0 May  5 21:50 logs_2.sqlite-wal
drwxr-xr-x    3 black.terminal  staff        96 Apr 19 18:26 memories
-rw-r--r--@   1 black.terminal  staff    245718 May  4 19:27 models_cache.json
drwxr-xr-x    3 black.terminal  staff        96 Mar 29 16:54 plugins
drwxr-xr-x    3 black.terminal  staff        96 Mar 15 11:21 rules
-rw-r--r--@   1 black.terminal  staff      1360 Apr  4 21:38 session_index.jsonl
drwxr-xr-x@   5 black.terminal  staff       160 May  4 22:10 sessions
drwxr-xr-x    3 black.terminal  staff        96 May  4 20:09 shell_snapshots
drwxr-xr-x   75 black.terminal  staff      2400 May  5 21:17 skills
drwxr-xr-x    3 black.terminal  staff        96 Apr 24 00:13 sqlite
-rw-r--r--@   1 black.terminal  staff    331776 May  5 21:08 state_5.sqlite
-rw-r--r--@   1 black.terminal  staff     32768 May  5 21:50 state_5.sqlite-shm
-rw-r--r--@   1 black.terminal  staff   3193032 May  5 21:50 state_5.sqlite-wal
drwxr-xr-x    4 black.terminal  staff       128 May  4 22:46 tmp
drwxr-xr-x    3 black.terminal  staff        96 May  2 19:05 vendor
drwxr-xr-x    4 black.terminal  staff       128 May  2 19:05 vendor_imports
-rw-r--r--@   1 black.terminal  staff       102 May  4 19:27 version.json
drwxr-xr-x    3 black.terminal  staff        96 Apr 26 14:23 worktrees
```

**Notable subpaths:**

- `/Users/black.terminal/.codex/AGENTS.md` (12698 bytes)
- `/Users/black.terminal/.codex/rules/` (1 entries)
- `/Users/black.terminal/.codex/skills/` (71 entries)
- `/Users/black.terminal/.codex/hooks/` (5 entries)
- `/Users/black.terminal/.codex/plugins/` (1 entries)
- `/Users/black.terminal/.codex/sessions/` (2 entries)

### Shared agents — `/Users/black.terminal/.agents`

```
total 16
drwxr-xr-x    4 black.terminal  staff   128 Apr 16 15:47 .
drwxr-x---+ 138 black.terminal  staff  4416 May  5 21:20 ..
-rw-r--r--@   1 black.terminal  staff  6148 May  4 22:10 .DS_Store
drwxr-xr-x   91 black.terminal  staff  2912 May  3 11:19 skills
```

**Notable subpaths:**

- `/Users/black.terminal/.agents/skills/` (88 entries)

### Windsurf — `/Users/black.terminal/.windsurf`

```
total 56
drwxr-xr-x@  19 black.terminal  staff   608 May  4 22:10 .
drwxr-x---+ 138 black.terminal  staff  4416 May  5 21:20 ..
-rw-r--r--@   1 black.terminal  staff  8196 May  4 22:10 .DS_Store
drwxr-xr-x    3 black.terminal  staff    96 Feb 19 00:09 args
-rw-r--r--@   1 black.terminal  staff   798 Mar 23 22:24 argv.json
drwxr-xr-x    7 black.terminal  staff   224 Mar 23 22:23 context
drwxr-xr-x    4 black.terminal  staff   128 Mar 20 01:44 data
drwxr-xr-x@  33 black.terminal  staff  1056 May  4 22:10 extensions
-rw-r--r--    1 black.terminal  staff   330 Apr 16 13:21 extensions.json
-rw-r--r--@   1 black.terminal  staff   950 Mar 21 17:00 extensions.json.20260321-170026.bak
drwxr-xr-x    3 black.terminal  staff    96 Feb 19 00:09 goals
drwxr-xr-x   10 black.terminal  staff   320 Mar 19 00:11 hardprompts
drwxr-xr-x   28 black.terminal  staff   896 Apr 16 18:31 plans
drwxr-xr-x@  11 black.terminal  staff   352 Apr 19 21:32 rules
-rw-r--r--    1 black.terminal  staff    98 Apr 16 13:21 settings.json
drwxr-xr-x   11 black.terminal  staff   352 Apr 17 02:54 skills
drwxr-xr-x    4 black.terminal  staff   128 Mar 12 18:23 tools
drwxr-xr-x    6 black.terminal  staff   192 Apr  1 01:39 workflows
drwxr-xr-x    4 black.terminal  staff   128 May  4 22:10 worktrees
```

**Notable subpaths:**

- `/Users/black.terminal/.windsurf/settings.json` (98 bytes)
- `/Users/black.terminal/.windsurf/rules/` (9 entries)
- `/Users/black.terminal/.windsurf/skills/` (9 entries)
- `/Users/black.terminal/.windsurf/extensions/` (30 entries)

### Codeium / Windsurf legacy — `/Users/black.terminal/.codeium`

```
total 24
drwxr-xr-x@   7 black.terminal  staff   224 May  4 22:10 .
drwxr-x---+ 138 black.terminal  staff  4416 May  5 21:20 ..
-rw-r--r--@   1 black.terminal  staff  8196 May  5 20:50 .DS_Store
drwxr-xr-x@   3 black.terminal  staff    96 Feb  7 00:29 e03af6ebc40b844314d448f947c80b636d093049
drwxr-xr-x@   3 black.terminal  staff    96 Feb  7 00:29 language_server_v1.48.2
drwxr-xr-x@   4 black.terminal  staff   128 Feb  7 00:29 language-server
drwxr-xr-x@  21 black.terminal  staff   672 May  4 22:10 windsurf
```

### Continue.dev — `/Users/black.terminal/.continue`

```
total 136
drwxr-xr-x@  26 black.terminal  staff   832 Apr 16 15:47 .
drwxr-x---+ 138 black.terminal  staff  4416 May  5 21:20 ..
-rw-r--r--@   1 black.terminal  staff   226 Feb 12 02:31 .continueignore
-rw-r--r--@   1 black.terminal  staff    31 Feb 12 02:31 .continuerc.json
-rw-r--r--@   1 black.terminal  staff  8196 Apr 16 15:47 .DS_Store
-rw-------    1 black.terminal  staff    93 Mar 30 22:41 .env
drwxr-xr-x@   8 black.terminal  staff   256 Feb 16 22:49 .migrations
-rw-r--r--@   1 black.terminal  staff    24 Feb 12 02:10 .onboarding_complete
drwxr-xr-x@   2 black.terminal  staff    64 Feb 12 00:08 .utils
drwxr-xr-x    4 black.terminal  staff   128 Mar 10 22:28 agents
-rw-r--r--@   1 black.terminal  staff   890 Feb 23 02:28 auth.json
-rw-r--r--    1 black.terminal  staff  3163 Mar 31 00:28 config.json
-rw-r--r--@   1 black.terminal  staff    73 Feb 12 00:08 config.ts
-rw-------@   1 black.terminal  staff  5370 Mar 31 00:28 config.yaml
-rw-r--r--@   1 black.terminal  staff   174 Feb 12 23:45 cspell.json
drwxr-xr-x@   4 black.terminal  staff   128 Apr 16 13:41 dev_data
drwxr-xr-x@   8 black.terminal  staff   256 Apr  4 20:12 index
-rw-r--r--@   1 black.terminal  staff   218 Feb 23 02:32 input_history.json
drwxr-xr-x@   3 black.terminal  staff    96 Feb 12 02:08 logs
drwxr-xr-x    3 black.terminal  staff    96 Mar 31 00:35 mcpServers
-rw-r--r--@   1 black.terminal  staff   105 Feb 12 00:08 package.json
-rw-r--r--@   1 black.terminal  staff   235 Feb 12 02:09 permissions.yaml
drwxr-xr-x@   6 black.terminal  staff   192 Mar 30 23:47 sessions
drwxr-xr-x    3 black.terminal  staff    96 Mar 20 01:35 skills
-rw-r--r--@   1 black.terminal  staff   595 Feb 12 00:08 tsconfig.json
drwxr-xr-x@   3 black.terminal  staff    96 Feb 12 00:08 types
```

**Notable subpaths:**

- `/Users/black.terminal/.continue/config.json` (3163 bytes)
- `/Users/black.terminal/.continue/skills/` (1 entries)
- `/Users/black.terminal/.continue/agents/` (2 entries)
- `/Users/black.terminal/.continue/logs/` (1 entries)
- `/Users/black.terminal/.continue/sessions/` (4 entries)

### Aider — `/Users/black.terminal/.aider`

```
total 16
drwxr-xr-x    5 black.terminal  staff   160 Feb 17 19:36 .
drwxr-x---+ 138 black.terminal  staff  4416 May  5 21:20 ..
-rw-r--r--    1 black.terminal  staff   113 Feb 17 19:35 analytics.json
drwxr-xr-x    4 black.terminal  staff   128 Feb 17 19:36 caches
-rw-r--r--    1 black.terminal  staff    91 Feb 17 19:36 installs.json
```

### Top-level agent rule files

- `/Users/black.terminal/AGENTS.md` (385 lines)
- `/Users/black.terminal/.claude/CLAUDE.md` (10 lines)
- `/Users/black.terminal/.codex/AGENTS.md` (271 lines)
- `/Users/black.terminal/.cursor/rules/gotcha.mdc` (83 lines)
- `/Users/black.terminal/.cursor/rules/gotcha-full.mdc` (272 lines)
- `/Users/black.terminal/.windsurf/rules/gotcha.md` (267 lines)
- `/Users/black.terminal/.codeium/windsurf/memories/global_rules.md` (158 lines)

### Skill counts per editor root

- `/Users/black.terminal/.claude/skills/` (30 skills)
- `/Users/black.terminal/.cursor/skills/` (7 skills)
- `/Users/black.terminal/.codex/skills/` (72 skills)
- `/Users/black.terminal/.codeium/windsurf/skills/` (27 skills)
- `/Users/black.terminal/.agents/skills/` (88 skills)

#### claude --version

`claude --version 2>/dev/null`

```
2.1.128 (Claude Code)
```

#### claude mcp list

`claude mcp list 2>/dev/null`

```
Checking MCP server health…

claude.ai Postman: https://mcp.postman.com/minimal - ! Needs authentication
claude.ai Vercel: https://mcp.vercel.com - ✓ Connected
claude.ai Supabase: https://mcp.supabase.com/mcp - ✓ Connected
claude.ai Google Drive: https://drivemcp.googleapis.com/mcp/v1 - ✓ Connected
claude.ai Gmail: https://gmailmcp.googleapis.com/mcp/v1 - ✓ Connected
github: /Users/black.terminal/.local/bin/github-mcp-server stdio - ✓ Connected
filesystem: npx -y @modelcontextprotocol/server-filesystem /Users/black.terminal/Projects - ✓ Connected
postgres: npx -y @modelcontextprotocol/server-postgres postgresql://localhost:5432/postgres - ✓ Connected
nansen: https://mcp.nansen.ai/ra/mcp (HTTP) - ✓ Connected
supabase: npx -y mcp-remote https://mcp.supabase.com/mcp - ✓ Connected
ollama: npx -y ollama-mcp - ✓ Connected
firecrawl: npx -y firecrawl-mcp - ✓ Connected
memory: npx -y @modelcontextprotocol/server-memory - ✓ Connected
bsela: node /Users/black.terminal/Projects/Current/Active/BEST-Self-Enhancement-Learning-AI/mcp/dist/server.js - ✓ Connected
sequential-thinking: npx -y @modelcontextprotocol/server-sequential-thinking - ✓ Connected
greptile: https://api.greptile.com/mcp (HTTP) - ✓ Connected
chrome-devtools: npx -y chrome-devtools-mcp@latest --executablePath=/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome Dev --userDataDir=/Users/black.terminal/Library/Application Support/Google/Chrome Dev - ✓ Connected
```

#### codex --version

`codex --version 2>/dev/null`

```
codex-cli 0.128.0
```

## Appendix: Missing commands or permission-limited checks

### Missing commands

- `mas` not found on PATH
- `bun` not found on PATH
- `poetry` not found on PATH
- `conda` not found on PATH
- `cargo` not found on PATH
- `rustup` not found on PATH
- `go` not found on PATH
- `composer` not found on PATH
- `php` not found on PATH
- `rustc` not found on PATH
- `fnm` not found on PATH
- `asdf` not found on PATH
- `rbenv` not found on PATH
- `docker` not found on PATH
- `podman` not found on PATH
- `colima` not found on PATH
- `orbstack` not found on PATH
- `psql` not found on PATH
- `pg_isready` not found on PATH

### Permission-limited or environment-dependent

- `sudo`-gated checks (system-level brew services, fdesetup detail, etc.) were not attempted — read-only mode.
- Function-only commands (e.g. `nvm`, `sdk`) cannot be detected via PATH; presence is inferred from `~/.nvm`, `~/.sdkman`.
- App version reflects `CFBundleShortVersionString` from Info.plist; missing plists print `?`.
- Mac App Store list requires `mas` and an active App Store session.
- `claude mcp list` and similar agent CLIs depend on the host context (project vs. global).

### Notes

- AI section is a *list-only* footprint of paths and config locations; no judgments.

---
*Generated by macos-machine-inventory skill — read-only.*
