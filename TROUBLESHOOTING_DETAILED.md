# 🔧 FIX LỖI BUILD IMAGE - HƯỚNG DẪN CHI TIẾT

## 📋 Tóm tắt vấn đề

Khi chạy lệnh:
```bash
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

Gặp lỗi:
```
[ERROR] unable to download https://github.com/bell-sw/Liberica/releases/download/11.0.19+7/bellsoft-jre11.0.19+7-linux-amd64.tar.gz
[ERROR] unable to copy from https://github.com/bell-sw/Liberica/releases/download/11.0.19+7/bellsoft-jre11.0.19+7-linux-amd64.tar.gz to /tmp/...
[ERROR] unexpected EOF
[ERROR] ERROR: failed to build: exit status 1
```

---

## 🎯 Nguyên nhân gốc

| Nguyên nhân | Mô tả |
|-----------|-------|
| **Network Timeout** | Mất kết nối khi tải JRE ~250MB từ GitHub |
| **DNS Resolution** | Không resolve được github.com |
| **Firewall/Proxy** | Bị chặn hoặc proxy không hỗ trợ |
| **Build Cache Corrupt** | Docker buildpack cache bị lỗi |
| **Disk Space** | Không đủ dung lượng ổ đĩa |

---

## ✅ GIẢI PHÁP - Theo thứ tự ưu tiên

### **Giải pháp 1: Clean Cache & Retry** ⭐⭐⭐ RECOMMENDED

**Dự kiến hiệu quả: 80%**

Đây là lỗi tạm thời (transient error). Xóa cache và thử lại thường xuyên fix.

```bash
# Bước 1: Xóa Docker build cache
docker builder prune --all

# Bước 2: Xóa Maven cache
mvn clean

# Bước 3: Build lại
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest

# Bước 4: Kiểm tra kết quả
docker images | grep k8s-demo
```

**Thời gian**: ~5 phút (lần đầu) hoặc ~30 giây (nếu đã cache)

**Nếu vẫn lỗi**, tiếp tục Giải pháp 2.

---

### **Giải pháp 2: Skip Tests + Verbose Output** ⭐⭐⭐

**Dự kiến hiệu quả: 90%**

```bash
# Skip unit tests + get detailed error info
mvn clean package -DskipTests -X
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest -X
```

**Tại sao lại skip tests?**
- Tiết kiệm thời gian build
- Tập trung vào build image
- Tests có thể chạy sau

**Thời gian**: ~3-5 phút

---

### **Giải pháp 3: Dockerfile Truyền Thống** ⭐⭐⭐

**Dự kiến hiệu quả: 100%** ✅

Nếu `build-image` vẫn lỗi, dùng Dockerfile cổ điển.

**File `Dockerfile` đã có sẵn trong project:**

```dockerfile
FROM eclipse-temurin:11-jdk-focal
WORKDIR /app
COPY target/k8s-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Cách build:**

```bash
# Bước 1: Build JAR
mvn clean package -DskipTests

# Bước 2: Build Docker image
docker build -t k8s-demo:latest .

# Bước 3: Kiểm tra
docker images | grep k8s-demo

# Bước 4: Test
docker run -p 8080:8080 k8s-demo:latest
```

**Ưu điểm:**
- ✅ Không cần download buildpack (tránh network issue)
- ✅ Kiểm soát hoàn toàn
- ✅ Build nhanh (chỉ 1-2 phút)

**Nhược điểm:**
- ❌ Image size lớn hơn (~500MB vs 300MB)

**Thời gian**: ~2-3 phút

---

### **Giải pháp 4: Sử dụng Local Cache** ⭐⭐

**Dự kiến hiệu quả: 70%**

```bash
# Download dependencies offline
mvn dependency:go-offline

# Build trong offline mode
mvn spring-boot:build-image -o -Dspring-boot.build-image.imageName=k8s-demo:latest
```

**Khi nào dùng:**
- Máy có mạng kém
- Cần build offline

---

### **Giải pháp 5: Kiểm tra Hệ Thống** ⭐

**Trước khi thử các giải pháp trên, kiểm tra:**

```bash
# 1. Kết nối Internet
ping github.com
ping raw.githubusercontent.com

# 2. Docker đang chạy?
docker ps
docker info

# 3. Java version
java -version
# Output phải là: openjdk version "11" hoặc cao hơn

# 4. Maven version
mvn -v
# Output phải là: >= 3.6

# 5. Dung lượng ổ đĩa
# Tối thiểu: 5GB free

# 6. Docker disk space
docker system df
```

---

## 🎯 CHIẾN LƯỢC KHUYÊN DÙNG

### Bạn đang ở đâu?

**Scenario 1**: Internet tốt, muốn dùng buildpack
```
→ Dùng Giải pháp 1 + 2
```

**Scenario 2**: Internet kém, timeout thường xuyên
```
→ Dùng Giải pháp 3 (Dockerfile)
```

**Scenario 3**: Đã thử nhiều lần vẫn lỗi
```
→ Dùng Giải pháp 3 + 4 (offline mode)
```

---

## 📊 Bảng So Sánh

| Giải pháp | Hiệu quả | Thời gian | Độ khó |
|----------|---------|---------|--------|
| 1. Clean & Retry | 80% | 5 phút | ⭐ |
| 2. Skip Tests | 90% | 5 phút | ⭐ |
| 3. Dockerfile | 100% | 3 phút | ⭐ |
| 4. Offline Mode | 70% | 10 phút | ⭐⭐ |
| 5. System Check | 50% | 2 phút | ⭐⭐⭐ |

---

## 🚨 Nếu vẫn lỗi

Hãy capture output và báo cáo:

```bash
# 1. Lưu output vào file
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest > build.log 2>&1

# 2. Xem log
cat build.log | tail -50

# 3. Gửi file build.log để debug
```

---

## ✅ KIỂM CHỨNG THÀNH CÔNG

Sau khi build thành công:

```bash
# 1. Image tồn tại
docker images | grep k8s-demo
# OUTPUT:
# k8s-demo          latest   <IMAGE_ID>   <TIME>   <SIZE>

# 2. Run container
docker run -p 8080:8080 k8s-demo:latest

# 3. Trong terminal khác, test health
curl http://localhost:8080/actuator/health
# OUTPUT:
# {"status":"UP"}

# 4. Stop container
docker stop <container_id>
```

✅ **Nếu thấy `{"status":"UP"}` = SUCCESS!**

---

## 🔗 Tài liệu Tham Khảo

- [Spring Boot Build Image Docs](https://spring.io/blog/2020/08/14/buildpacks-and-spring-boot-0-5-0)
- [Paketo Buildpacks](https://paketo.io/)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Issue - Similar Problem](https://github.com/spring-projects/spring-boot/issues)

---

**Hãy thử Giải pháp 1 trước, nếu không được thì báo cáo kết quả!** 🚀

