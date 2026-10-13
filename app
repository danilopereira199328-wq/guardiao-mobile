name: Build APK

on:
  push:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Descarregar código
        uses: actions/checkout@v4

      - name: Extrair projeto (app/) do ZIP
        run: |
          if [ -f guardiao-mobile-github.zip ]; then
            unzip -o guardiao-mobile-github.zip -d .
          else
            echo "Sem ZIP — a assumir que a pasta app/ já está no repositório"
          fi

      - name: Instalar Java 17
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'

      - name: Instalar Gradle 8.9
        uses: gradle/actions/setup-gradle@v3
        with:
          gradle-version: '8.9'

      - name: Compilar APK (debug)
        run: gradle assembleDebug --no-daemon

      - name: Publicar APK como artefacto
        uses: actions/upload-artifact@v4
        with:
          name: guardiao-mobile-apk
          path: app/build/outputs/apk/debug/*.apk
          retention-days: 30
