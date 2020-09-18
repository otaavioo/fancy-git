#!/bin/bash
#
# Author: Diogo Alexsander Cavilha <diogocavilha@gmail.com>
# Date:   06.06.2018

. ~/.fancy-git/aliases
. ~/.fancy-git/fancygit-completion
. ~/.fancy-git/commands.sh

fancygit_prompt_builder() {
    . ~/.fancy-git/config.sh
    . ~/.fancy-git/update_checker.sh && _fancygit_update_checker

    # Prompt style
    path="${bg_blue}${white}${bold}"
    path_git="${bg_blue}${white}  ${is_git_repo} ${bold}"
    path_end="${none}${bold_none}"
    user_symbol="${bg_dark_gray}${bold}${white}"
    user_symbol_end="${none}${bold_none}${bg_none}${s_dark_gray_bgnone}"
    branch="${s_blue_bgwhite}${bg_white}${black}${bold}"
    branch_end="${bg_none}${none}${bold_none}${s_white}"
    local venv=""
    local path_sign=""
    local prompt_user=""

    # Building prompt
    if [ "$branch_status" != "" ]
    then
        branch="${s_blue_bglightyellow}${bg_light_yellow}${black}${bold}"
        branch_end="${bg_none}${bold_none}${s_lightyellow}"
    fi

    if [ "$staged_files" = "" ]
    then
        has_added_files=""
    fi

    if [ "$staged_files" != "" ]
    then
        branch="${s_blue_bglightgreen}${bg_light_green}${black}${bold}"
        branch_end="${bg_none}${bold_none}${s_green}"
    fi

    if [ "$git_stash" = "" ]
    then
        has_git_stash=""
    fi

    if [ "$git_untracked_files" = "" ]
    then
        has_untracked_files=""
    fi

    if [ "$git_changed_files" = "" ]
    then
        has_changed_files=""
    fi

    has_unpushed_commits="$has_unpushed_commits+$git_number_unpushed_commits"
    if [ "$git_has_unpushed_commits" = "" ]
    then
        has_unpushed_commits=""
    fi

    if fg_show_user_at_machine
    then
        user_at_host="${white}${bg_dark_gray}${bold}"
        user_at_host_end="${bold_none}${bg_none}${s_darkgray_bgblue}"
        prompt_user="${user_at_host}\\u@\\h ${user_at_host_end}"
    fi

    prompt_symbol="\n${user_symbol}\$${user_symbol_end}"

    if ! [ -z ${VIRTUAL_ENV} ]
    then
        venv="$working_on_venv"
    fi

    path_sign="\\W"
    if fg_show_full_path
    then
        path_sign="\\w"
    fi

    prompt_path="${path}${bold}${white}${venv} $path_sign ${path_end}${s_blue}"

    if [ "$branch_name" != "" ]
    then
        branch_icon=$(fg_get_branch_icon)
        prompt_path="${path_git}${venv}${has_git_stash}${has_untracked_files}${has_changed_files}${has_added_files}${has_unpushed_commits} $path_sign ${path_end}"
        prompt_branch="${branch} ${branch_icon} ${branch_name} ${branch_end}"
        PS1="${prompt_user}${prompt_path}${prompt_branch}${prompt_symbol} "
        return
    fi

    PS1="${prompt_user}${prompt_path}${prompt_symbol} "
}

PROMPT_COMMAND="fancygit_prompt_builder"
