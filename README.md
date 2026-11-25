# Neovim 설정

[lazy.nvim](https://github.com/folke/lazy.nvim) 기반의 개인 Neovim 설정입니다.
터미널 Neovim과 VSCode([vscode-neovim](https://github.com/vscode-neovim/vscode-neovim)) 양쪽에서 동작합니다.

- **Neovim**: 0.11 이상 (`vim.lsp.config` / `vim.lsp.enable`, `winborder` 사용)
- **Leader 키**: `,` (`<leader>`와 `<localleader>` 모두)
- **컬러스킴**: kanagawa-wave (catppuccin, tokyonight도 설치됨)
- **주 사용 언어**: C/C++(Zephyr `west`, Arduino ESP32-C3), Python, Lua, CMake, Shell, Markdown

## 구조

```
init.lua                 진입점: VSCode / 터미널 환경 분기, WSL 클립보드, 줄바꿈 처리
lua/plugin.lua           터미널용 플러그인 목록 (lazy.nvim bootstrap)
lua/plugin-vscode.lua    VSCode용 플러그인 목록 (UI 플러그인 제외)
lua/config/basic.lua     터미널용 옵션 · 키맵 · autocmd
lua/config/vscode.lua    VSCode용 옵션 · 키맵
lua/plugins/*.lua        플러그인별 설정 (plugin.lua에서 require 하는 것만 활성)
lazy-lock.json           플러그인 버전 고정 (:Lazy restore 로 복원)
```

## 설치

```sh
git clone https://github.com/bradkim06/my_neovim_settings.git ~/.config/nvim
nvim   # 첫 실행 시 lazy.nvim과 플러그인, Mason이 LSP 서버를 자동 설치
```

외부 도구 (PATH에 있어야 함):

| 용도 | 도구 |
|---|---|
| 검색 (Telescope) | `fd`, `ripgrep`, `file` |
| Git | `lazygit` |
| 포매터 (conform) | `clang-format`, `cmake-format`, `shfmt`, `stylua`, `ruff`, `prettier`, `prettierd` |
| 린터 (nvim-lint) | `clang-tidy`, `cmakelint`, `markdownlint` |
| Markdown 브라우저 미리보기 | `node`, `yarn` |
| Arduino LSP | `arduino-cli` (`~/.config/arduino-cli/arduino-cli.yaml`) |
| Python provider | `python3` (+ `pynvim`) |

## 주요 기능

| 분류 | 플러그인 / 설정 |
|---|---|
| LSP | nvim-lspconfig + mason: `clangd`, `pyright`, `lua_ls`, `jsonls`, `marksman`, `neocmake`, `vimls`, `arduino_language_server` |
| 자동완성 | nvim-cmp + LuaSnip + lspkind, cmdline(`/`, `:`) 완성 |
| 포맷 | conform.nvim, **저장 시 자동 포맷** (포매터 없으면 LSP로 fallback) |
| 린트 | nvim-lint, 파일 열기/저장 시 실행 |
| 문법 | nvim-treesitter (master) + textobjects |
| 검색 | telescope.nvim (바이너리 파일은 미리보기 생략) |
| Git | gitsigns, lazygit.nvim, diffview.nvim |
| UI | lualine, bufferline, which-key, todo-comments, nvim-colorizer |
| 편집 | Comment.nvim, nvim-surround, nvim-autopairs, neogen(Doxygen 주석) |
| Markdown | render-markdown.nvim(기본 꺼짐, 분할 미리보기/토글), markdown-preview.nvim(브라우저) |
| 기타 | toggleterm(플로팅 터미널), sniprun(코드 조각 실행) |

기본 동작:

- 4칸 공백 들여쓰기, `textwidth=80`, 80열 표시, 영구 undo
- 시스템 클립보드 사용 (WSL에서는 `clip.exe` / PowerShell 사용)
- 파일 인코딩 자동 판별: `ucs-bom → utf-8 → cp949 → latin1`
- 저장 시 `^M`(CR) 제거, unix 줄바꿈 우선
- 파일을 다시 열면 마지막 커서 위치로 복원 (git 커밋 메시지는 제외)
- `*.json`은 `jsonc`로 인식 (주석 허용)

---

## 단축키 Cheat Sheet

> `<leader>` = `,`  모드 표기: **n** Normal · **i** Insert · **x** Visual · **t** Terminal
> 어떤 키가 있는지 기억나지 않으면 `,`를 누르고 기다리면 which-key 팝업이 뜹니다.

### 일반 / 버퍼

| 키 | 모드 | 동작 |
|---|---|---|
| `<Tab>` / `<S-Tab>` | n | 다음 / 이전 버퍼 |
| `<leader>q` | n | 현재 버퍼 닫기 |
| `<S-q>` | n | 현재 버퍼만 남기고 모두 닫기 (`:BufOnly`) |
| `<C-a>` | n | 전체 선택 |
| `*` / `#` | x | 선택한 텍스트로 앞 / 뒤 검색 |
| `<leader>n` | n | 현재 파일 이름 변경 |
| `<F5>` | i | 날짜 입력 `YYYY-MM-DD` |
| `<F6>` | i | 날짜·시간 입력 `YYYY-MM-DDTHH:MM:SS` |
| `<F3>` / `<F4>` | n | `west build` / `west flash` |

### 설정 파일

| 키 | 동작 |
|---|---|
| `<leader>ve` | `init.lua` 열기 |
| `<leader>vl` | `lua/config/basic.lua` 열기 |
| `<leader>vs` | 현재 파일 다시 불러오기 (`:source %`, 옵션·키맵 수정 반영용) |

### 검색 (Telescope)

| 키 | 동작 |
|---|---|
| `<leader><leader>` | 파일 찾기 (숨김 파일 포함, `.git`/`.cache` 제외) |
| `<leader>g` | 파일 찾기 (gitignore 무시, 전체) |
| `<leader>/` | 프로젝트 전체 live grep |
| `<leader>ag` | 커서 아래 단어 grep |
| `<F1>` | Telescope 피커 목록 |
| `:Grep <word>` | 단어 grep |
| `<M-p>` (Telescope 안) | 미리보기 토글 |
| `<Esc>` (Telescope 안) | 닫기 |

### LSP / 진단

| 키 | 동작 | 비고 |
|---|---|---|
| `gd` | 정의로 이동 | Telescope |
| `grr` | 참조 목록 | Telescope |
| `gG` | 워크스페이스 진단 목록 | Telescope |
| `<leader>rn` | 심볼 이름 변경 | |
| `K` | Hover 문서 | Neovim 기본 |
| `[d` / `]d` | 이전 / 다음 진단 | Neovim 기본 |
| `<C-w>d` | 커서 위치 진단 팝업 | Neovim 기본 |
| `grn` | 심볼 이름 변경 | Neovim 기본 |
| `gra` | 코드 액션 | Neovim 기본 |
| `grt` | 타입 정의로 이동 | Neovim 기본 |
| `gri` | 구현으로 이동 | Neovim 기본 |
| `gO` | 문서 심볼 | Neovim 기본 |
| `<C-s>` (i) | 시그니처 도움말 | Neovim 기본 |
| `:Format` | 수동 포맷 (범위 지정 가능) | conform |


### 자동완성 (nvim-cmp, Insert 모드)

| 키 | 동작 |
|---|---|
| `<Tab>` | 다음 후보 (후보가 1개면 바로 확정) / 스니펫 확장·점프 / 완성 열기 |
| `<S-Tab>` | 이전 후보 / 스니펫 뒤로 점프 |
| `<CR>` | 선택한 후보 확정 (선택이 없으면 줄바꿈) |
| `<C-Space>` | 완성 메뉴 열기 |
| `<C-c>` | 완성 취소 |
| `<C-u>` / `<C-d>` | 문서 창 스크롤 |
| `<C-f>` / `<C-b>` | 스니펫 다음 / 이전 위치로 점프 |

### Treesitter

| 키 | 모드 | 동작 |
|---|---|---|
| `af` / `if` | x, o | 함수 바깥 / 안쪽 |
| `ac` / `ic` | x, o | 클래스 |
| `ap` / `ip` | x, o | 매개변수 |
| `aa` / `ia` | x, o | 함수 호출 |
| `ad` / `id` | x, o | 조건문 |
| `al` / `il` | x, o | 반복문 |
| `as` / `is` | x, o | 문장 |
| `ab` / `ib` | x, o | 블록 |
| `]f` / `[f` | n | 다음 / 이전 함수 시작 |
| `]C` / `[C` | n | 다음 / 이전 클래스 시작 |
| `gnn` | n | 노드 선택 시작 |
| `grn` / `grm` | x | 노드 단위 확장 / 축소 |
| `grc` | x | scope 단위 확장 |

예: `daf` 함수 삭제, `vic` 클래스 내부 선택, `cip` 매개변수 바꾸기

### Git

| 키 | 동작 |
|---|---|
| `]h` / `[h` | 다음 / 이전 변경 hunk (diff 모드에서는 `]c`/`[c`) |
| `<leader>h` | hunk 미리보기 |
| `<F2>` | lazygit 열기 |
| `:DiffviewOpen` / `:DiffviewClose` | diff 뷰 열기 / 닫기 |
| `]c` / `[c` | diff 모드에서 다음 / 이전 변경 |

### 편집 플러그인

| 키 | 동작 | 플러그인 |
|---|---|---|
| `gcc` / `gc{motion}` | 줄 / 범위 주석 토글 | Comment.nvim |
| `gbc` / `gb{motion}` | 블록 주석 토글 | Comment.nvim |
| `ys{motion}{char}` | 감싸기 (예: `ysiw"`) | nvim-surround |
| `ds{char}` | 감싼 문자 삭제 (예: `ds(`) | nvim-surround |
| `cs{old}{new}` | 감싼 문자 바꾸기 (예: `cs"'`) | nvim-surround |
| `S{char}` (x) | 선택 영역 감싸기 | nvim-surround |
| `:Neogen` | 함수/클래스 문서 주석 생성 | neogen |
| `:SnipRun` | 현재 줄 / 선택 영역 실행 | sniprun |

### 터미널 / Markdown

| 키 | 모드 | 동작 |
|---|---|---|
| `<C-\>` | n, i, t | 플로팅 터미널 토글 |
| `<leader>t` | n | 플로팅 터미널 토글 |
| `<leader>mp` | n | Markdown 분할 미리보기 토글 (render-markdown) |
| `<leader>mr` | n | 현재 버퍼에서 Markdown 렌더링 토글 (기본은 꺼짐) |
| `:MarkdownPreviewToggle` | | 브라우저 미리보기 토글 |

---

## VSCode 모드

`vim.g.vscode`가 설정되면 `lua/plugin-vscode.lua` + `lua/config/vscode.lua`만 불러옵니다.
UI 계열(telescope, lualine, LSP, cmp UI 등)은 VSCode가 담당하고, 편집용 플러그인
(treesitter, Comment, surround, todo-comments, lastplace 등)과 위의 일반 키맵 일부
(`<Tab>`, `<leader>q`, `<C-a>`, `*`/`#`, `<F5>`/`<F6>`)만 동일하게 동작합니다.
파일 이름 변경은 VSCode 탐색기의 `F2`를 사용하세요.

## 유지보수

- 플러그인 업데이트: `:Lazy update` 후 동작 확인되면 `lazy-lock.json` 커밋
- 업데이트로 문제가 생기면: `git checkout lazy-lock.json && :Lazy restore`
- LSP 서버 관리: `:Mason`
- 상태 점검: `:checkhealth`, `:LspInfo`, `:ConformInfo`
