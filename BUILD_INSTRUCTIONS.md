# HƯỚNG DẪN FIX LỖI BUILD IMAGE

## Lỗi gặp phải

```
unable to download https://github.com/bell-sw/Liberica/releases/download/11.0.19+7/bellsoft-jre11.0.19+7-linux-amd64.tar.gz
unexpected EOF
```

## Nguyên nhân

- Network timeout khi tải JRE từ GitHub
- Hoặc bộ cache bị lỗi

## Giải pháp

### Cách 1: Clean Cache và Retry (Khuyên dùng)

```bash
# Xóa build cache của Docker
docker builder prune --all

# Clean Maven cache
mvn clean

# Chạy lại build-image
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

### Cách 2: Build với Skip Tests

```bash
mvn clean package -DskipTests
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest -DskipTests
```

### Cách 3: Sử dụng Dockerfile truyền thống

Nếu build-image vẫn lỗi, có thể dùng Dockerfile:

```bash
docker build -t k8s-demo:latest .
```

Dockerfile đã có sẵn trong project.

### Cách 4: Sử dụng Maven offline

```bash
# Trước tiên tải dependencies khi có mạng
mvn dependency:go-offline

# Sau đó có thể build offline
mvn spring-boot:build-image -o -Dspring-boot.build-image.imageName=k8s-demo:latest
```

## Kiểm tra kết quả

Sau khi build thành công:

```bash
# Kiểm tra image
docker images | grep k8s-demo

# Chạy thử
docker run -p 8080:8080 k8s-demo:latest

# Trong terminal khác
curl http://localhost:8080/actuator/health
```

## Nếu vẫn lỗi

Hãy kiểm tra:

1. **Kết nối Internet**: `ping github.com`
2. **Docker đang chạy**: `docker ps`
3. **Java version**: `java -version` (phải >= 11)
4. **Maven version**: `mvn -v` (phải >= 3.6)

Nếu vẫn gặp vấn đề, liên hệ để debug chi tiết hơn.

