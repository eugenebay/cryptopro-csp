# HowToBuild

- Добавь root сертификат УЦ в папку config/certificates
- Добавь персональный файл в pfx-формате в папку config/certificates

### Аргументы для запуска:

> Обратите внимание на наличие обязательных аргументов.

- LICENSE - Лицензия CryptoPro CSP (Не обязательный аргумент - будет использована триальная лицензия на 90 дней)
- CA_ROOT_CERT - CryptoPro CA Root Certificate (__Обязательный аргумент__)
- CONTAINER_NAME=Admin - Имя контейнера CryptoPro CSP (Не обязательный аргумент - будет использовано стандартное значение "Admin")
- CLIENT_PFX_FILE - PFX-файл в котором связан сертификат с ключами (__Обязательный аргумент__)
- CLIENT_PFX_PASSWORD - Пароль от PFX-файла (__Обязательный аргумент__)
- CLIENT_CERT_THUMB - Отпечаток сертификата хранящегося в PFX-файле (__Обязательный аргумент__)

---

### Как получить отпечаток (Thumbprint) сертификата из PFX файла

- Извлечь сертификат из PFX в PEM формат:
```bash
openssl pkcs12 -in ваш_файл.pfx -clcerts -nokeys -out cert.pem
```
- Получить отпечаток сертификата
```bash
openssl x509 -in cert.pem -fingerprint -sha1 -noout
```
- В консоли будет выведено
```bash
sha1 Fingerprint=86:1D:44:D7:E2:40:57:19:65:3C:80:FB:C2:B9:D2:81:84:72:E6:8
```
- Убрать __":"__ , перевести в нижний регистр, это и будет отпечаток требующийся для образа
```bash
861d44d7e2405719653c80fbc2b9d2818472e68
```

---

```bash
    docker build \
    --build-arg LICENSE=xxxxx-xxxxx-xxxxx-xxxxx-xxxxx \
    --build-arg CA_ROOT_CERT=RootCertificate.cer \
    --build-arg CONTAINER_NAME=ContainerName \
    --build-arg CLIENT_PFX_FILE=PersonalPfxFile.pfx \
    --build-arg CLIENT_PFX_PASSWORD=PersonalPfxFilePassword \
    --build-arg CLIENT_CERT_THUMB=PersonalCertificateThunmprintFromPfxFile \
    -t cryptopro-csp-stunnel .
```

```shell
    docker build `
    --build-arg CA_ROOT_CERT=RootCertificate.cer `
    --build-arg CONTAINER_NAME=ContainerName `
    --build-arg CLIENT_PFX_FILE=PersonalPfxFile.pfx `
    --build-arg CLIENT_PFX_PASSWORD=PersonalPfxFilePassword `
    --build-arg CLIENT_CERT_THUMB=PersonalCertificateThunmprintFromPfxFile `
    -t cryptopro-csp-stunnel .
```