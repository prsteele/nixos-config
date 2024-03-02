# Adapted from various themes at https://github.com/ohmyzsh/ohmyzsh/blob/master/themes

# Box drawing characters
# ─  ━  │  ┃  ┄  ┅  ┆  ┇  ┈  ┉  ┊  ┋  ┌  ┍  ┎  ┏
# ┐  ┑  ┒  ┓  └  ┕  ┖  ┗  ┘  ┙  ┚  ┛  ├  ┝  ┞  ┟
# ┠  ┡  ┢  ┣  ┤  ┥  ┦  ┧  ┨  ┩  ┪  ┫  ┬  ┭  ┮  ┯
# ┰  ┱  ┲  ┳  ┴  ┵  ┶  ┷  ┸  ┹  ┺  ┻  ┼  ┽  ┾  ┿
# ╀  ╁  ╂  ╃  ╄  ╅  ╆  ╇  ╈  ╉  ╊  ╋  ╌  ╍  ╎  ╏
# ═  ║  ╒  ╓  ╔  ╕  ╖  ╗  ╘  ╙  ╚  ╛  ╜  ╝  ╞  ╟
# ╠  ╡  ╢  ╣  ╤  ╥  ╦  ╧  ╨  ╩  ╪  ╫  ╬  ╭  ╮  ╯
# ╰  ╱  ╲  ╳  ╴  ╵  ╶  ╷  ╸  ╹  ╺  ╻  ╼  ╽  ╾  ╿

local blue="%{$fg[blue]%}"
local white="%{$fg[white]%}"
local black="%{$fg[black]%}"
local red="%{$fg[red]%}"
local green="%{$fg[green]%}"
local yellow="%{$fg[yellow]%}"
local cyan="%{$fg[cyan]%}"
local magenta="%{$fg[magenta]%}"
local reset="%{$reset_color%}"

local sep="${blue}┄${reset}"
local time="${green}%*${reset}"
local user="${cyan}%n${reset}@${cyan}%m${reset}"
local dir="${yellow}%~${reset}"
local exit_code="%(?,, ${sep} ${red}%?${reset})"

local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX=" ${sep} %{$reset_color%}%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓"

local venv_info='$(virtenv_prompt)'
virtenv_prompt() {
    [[ -n "${VIRTUAL_ENV:-}" ]] || return
    echo " ${sep} ${red}λ:${VIRTUAL_ENV:t}${reset}"
}

PROMPT="
${blue}╭──${reset}${blue}${reset} ${time} ${sep} ${user} ${sep} ${dir}${git_info}${venv_info}${exit_code}
${blue}╰─❯${reset} "
