#!/bin/bash
#mewms.sh
clear
main() {
    clear
    echo '晨雾英语单词管理系统'
    echo '
0. 退出
1. 添加单词
2. 查看所有单词
3. 删除单词
4. 插入单词
5. 修改单词
'
    echo -n '请选择:'
    read -n1 us
    case $us in
    0)
        echo -e "\n"
        return
        ;;
    1)
        add
        ;;
    2)
        view
        ;;
    3)
        remove
        ;;
    4)
        insert
        ;;
    5)
        modify
        ;;
    *)
        echo -e "\n无效的选项，请重新选择！"
        sleep 2
        main
        ;;
    esac
}

add(){
    clear
    echo '添加单词'
    read -p "请输入单词(或者英语句子)名:" wosn
    read -p "输入这个单词(或者句子)的释义:" defin
    read -p "输入备注(可空):" rem
    echo "$wosn,$defin,$rem" >> $HOME/.mewms/.words.txt
    if [[ $? == 0 ]]; then
        echo '添加成功.'
        sleep 1
        main
    else 
        echo '没有添加成功.'
        sleep 1
        main
    fi
}
view(){
    clear
    echo "查看单词"
    echo -e "单词\t释义\t备注"
    while IFS=',' read -r wosn defin rem; do
        echo -e "${wosn}\t${defin}\t${rem}"
    done < $HOME/.mewms/.words.txt
    echo '----------'
    echo -n '按任意键退出...'
    read -n1 -s
    clear
    main
}
remove() {
    clear
    echo '删除单词'
    echo -e "单词\t释义\t备注"
    while IFS=',' read -r wosn defin rem; do
        echo -e "${wosn}\t${defin}\t${rem}"
    done < $HOME/.mewms/.words.txt
    echo '----------'
    echo -n "请输入要删除的单词: "
    read -r word_to_remove
    while IFS=',' read -r wosn defin rem; do
        if [[ "$wosn" != "$word_to_remove" ]]; then
            echo "$wosn,$defin,$rem" >> $HOME/.mewms/.temp_words.txt
        fi
    done < $HOME/.mewms/.words.txt
    mv $HOME/.mewms/.temp_words.txt $HOME/.mewms/.words.txt
    if [[ $? == 0 ]]; then
        echo '删除成功.'
    else
        echo '删除失败.'
    fi
    sleep 1
    main
}
insert() {
    clear
    echo '插入单词'
    echo -e "现有单词列表:"
    while IFS=',' read -r wosn defin rem; do
        echo -e "${wosn}\t${defin}\t${rem}"
    done < $HOME/.mewms/.words.txt
    echo '----------'
    echo -n "插入到哪个单词前面: "
    read -r position_word
    echo -n "输入单词名: "
    read -r new_word
    echo -n "输入释义: "
    read -r new_defin
    echo -n "输入备注(可空): "
    read -r new_rem
    local temp_words=()
    local found=false
    local temp_file="$HOME/.mewms/.temp_words.txt"
    > "$temp_file"
    while IFS=',' read -r wosn defin rem; do
        if [[ "$wosn" == "$position_word" ]]; then
            echo "$new_word,$new_defin,$new_rem" >> "$temp_file"
            found=true
        fi
        echo "$wosn,$defin,$rem" >> "$temp_file"
        if [[ "$found" == true ]]; then
            break
        fi
    done < $HOME/.mewms/.words.txt
    if [[ $found == false ]]; then
        echo '指定的单词不存在，插入到列表末尾。'
    else
        while IFS=',' read -r wosn defin rem; do
            echo "$wosn,$defin,$rem" >> "$temp_file"
        done < $HOME/.mewms/.words.txt
    fi
    mv "$temp_file" "$HOME/.mewms/.words.txt"
    if [[ $? == 0 ]]; then
        echo '插入成功.'
    else
        echo '插入失败.'
    fi
    sleep 2
    main
}
modify() {
    clear
    echo '修改单词'
    echo -e "单词\t释义\t备注"
    while IFS=',' read -r wosn defin rem; do
        echo -e "${wosn}\t${defin}\t${rem}"
    done < $HOME/.mewms/.words.txt
    echo '----------'
    echo -n "请输入要修改的单词: "
    read -r word_to_modify
    echo -n "请输入新的释义: "
    read -r new_defin
    echo -n "输入新的备注(可空): "
    read -r new_rem
    local temp_words=()
    local temp_file="$HOME/.mewms/.temp_words.txt"
    > "$temp_file"
    while IFS=',' read -r wosn defin rem; do
        if [[ "$wosn" == "$word_to_modify" ]]; then
            echo "$word_to_modify,$new_defin,$new_rem" >> "$temp_file"
        else
            echo "$wosn,$defin,$rem" >> "$temp_file"
        fi
    done < $HOME/.mewms/.words.txt
    mv "$temp_file" "$HOME/.mewms/.words.txt"
    if [[ $? == 0 ]]; then
        echo '修改成功.'
    else
        echo '修改失败.'
    fi
    sleep 1
    main
}
if [ -d $HOME/.mewms ] || [ -f $HOME/.mewms/.words.txt ]; then
    main
else
    mkdir $HOME/.mewms
    touch $HOME/.mewms/.words.txt
    main
fi
