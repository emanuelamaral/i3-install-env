#!/bin/sh

PACMAN_PACKAGES_LIST=("thunar" "spectacle" "picom" "kate" "btop" "polybar" "rofi" "i3" "i3lock" "feh" "neovim" "firefox" "python-pywal" "pavucontrol" "pipewire-alsa" "pipewire-pulse")
YAY_PACKAGES_LIST=("termite" "rofi-greenclip")

CONFIG_FILES=("i3" "greenclip" "nvim" "picom" "polybar" "rofi" "run-greenclip.sh" "termite")

AUSENT_PACMAN_PACKAGES=()
AUSENT_YAY_PACKAGES=()

if [ -z "$PACMAN_PACKAGES_LIST" ]; then
    echo "A lista dos pacotes pacman está vazia."
    exit 1
fi

if [ -z "$YAY_PACKAGES_LIST" ]; then
    echo "A lista dos pacotes yay está vazia."
    else 
      for package in "${YAY_PACKAGES_LIST[@]}"; do
        if  pacman -Qs "$package" >/dev/null 2>&1; then
            echo "$package está instalado."
        else
            echo "$package não está instalado."
            AUSENT_YAY_PACKAGES=("$package")
        fi
      done
fi

if [ ${#AUSENT_YAY_PACKAGES[@]} -gt 0 ]; then
    echo "Os seguintes programas estão ausentes: ${AUSENT_YAY_PACKAGES[@]}"
    read -p "Deseja instalar os programas ausentes? (s/n): " choose

    if [ "$choose" = "s" ] || [ "$choose" = "S" ]; then
        for package in "${AUSENT_YAY_PACKAGES[@]}"; do
            yay -S "$package"
        done
        echo "Instalação concluída."
    else
        echo "Instalação cancelada."
    fi
else
    echo "Todos os programas e pacotes AUR estão instalados."
fi

echo "VERIFICANDO PACOTES EXTRAS"

for package in "${PACMAN_PACKAGES_LIST[@]}"; do
    if  pacman -Qs "$package" >/dev/null 2>&1; then
        echo "$package está instalado."
    else
        echo "$package não está instalado."
        AUSENT_PACMAN_PACKAGES+=("$package")
    fi
done

if [ ${#AUSENT_PACMAN_PACKAGES[@]} -gt 0 ]; then
    echo "Os seguintes programas estão ausentes: ${AUSENT_PACMAN_PACKAGES[@]}"
    read -p "Deseja instalar os programas ausentes? (s/n): " choose

    if [ "$choose" = "s" ] || [ "$choose" = "S" ]; then
        for package in "${AUSENT_PACMAN_PACKAGES[@]}"; do
            sudo pacman -S "$package"
        done
        echo "Instalação concluída."

        DIR=$(dirname "$0")
        for file in "${CONFIG_FILES[@]}"; do

          if [ -d "$DIR/$file" ]; then
              cp -r "$DIR/$file" ~/.config/
          fi
        done
        echo "Configuração concluída."
    else
        echo "Instalação cancelada."
    fi
else
    echo "Todos os programas estão instalados."
fi

exit 0






