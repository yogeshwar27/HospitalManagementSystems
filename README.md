# MediKiosk · Hospital Management & Appointment System

MediKiosk is a full-stack hospital management, outpatient appointment scheduling, and electronic health record (EHR) system.

The project is structured into three clean, decoupled layers:
1. **Frontend Layer**: React 19 Single Page Application (SPA) with responsive UI, live kiosk queue board, and role-based portals.
2. **Backend Layer**: Java Spring Boot 3.2 REST API with 3-tier architecture (Controller → Service → Repository) and Spring Data JPA.
3. **Database Layer**: Relational SQL Database (MySQL / PostgreSQL / SQLite) with normalized schema, foreign keys, and indexes.

---

## 1. System Architecture (3-Tier Separation)

```
       ┌────────────────────────────────────────────────────────┐
       │                 LAYER 1: FRONTEND                      │
       │  React 19 + Tailwind CSS + Role-Based Access Control   │
       │  • Patient Kiosk   • Doctor Portal   • Admin Dashboard │
       └───────────────────────────┬────────────────────────────┘
                                   │ HTTP / JSON REST APIs
                                   ▼
       ┌────────────────────────────────────────────────────────┐
       │                 LAYER 2: BACKEND                       │
       │        Java Spring Boot 3.2.4 REST Service             │
       │  • AuthController     • AppointmentController          │
       │  • PatientController  • DoctorController               │
       │  • AppointmentService • Spring Data JPA Repositories   │
       └───────────────────────────┬────────────────────────────┘
                                   │ JDBC Driver / SQL
                                   ▼
       ┌────────────────────────────────────────────────────────┐
       │                 LAYER 3: DATABASE                      │
       │        Relational Database (MySQL / PostgreSQL)        │
       │  • users              • patients                       │
       │  • doctors            • appointments                   │
       │  • patient_records (EHR, vitals, prescriptions)        │
       └────────────────────────────────────────────────────────┘
```

---

## 2. Default Login Credentials (Role-Based Access Control)

Use these credentials to log in as **Admin**, **Doctor**, or **Patient**:

| Role | Username / Email | Password | Access Rights |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@medikiosk.com`<br>*(or `admin`)* | `AdminPassword123` | Full hospital access: all OPD queues, doctor roster, patient directory, SQL schema console, and Spring Boot API monitor. |
| **Doctor** | `dr.jenkins@medikiosk.com`<br>*(or `dr.jenkins`)* | `DoctorPassword123` | Physician portal: manage assigned patient appointments, record clinical diagnoses, enter vitals (BP, pulse, temp, SpO2, weight), and prescribe medications. |
| **Patient** | `patient@medikiosk.com`<br>*(or `patient`)* | `PatientPassword123` | Patient portal: book outpatient appointments, view queue token slips, inspect active prescriptions, and view personal EHR history. |

---

## 3. Directory Structure

```
/
├── database/                          # LAYER 3: Relational Database
│   ├── schema.sql                     # Full DDL (tables, primary/foreign keys, indexes)
│   ├── data.sql                       # Clean seed data (users, doctors, patients, appointments)
│   └── queries.sql                    # Production SQL queries (JOINs, aggregations, reports)
│
├── backend/                           # LAYER 2: Java Spring Boot 3.2
│   ├── pom.xml                        # Maven dependencies (Web, JPA, Security, MySQL)
│   └── src/main/
│       ├── resources/
│       │   ├── application.properties # Server port 8080 & MySQL datasource config
│       │   ├── schema.sql
│       │   └── data.sql
│       └── java/com/medikiosk/
│           ├── MediKioskApplication.java
│           ├── model/                 # JPA Entities (@Entity, @Table)
│           │   ├── User.java
│           │   ├── Patient.java
│           │   ├── Doctor.java
│           │   ├── Appointment.java
│           │   └── PatientRecord.java
│           ├── repository/            # Spring Data JPA (@Repository)
│           │   ├── UserRepository.java
│           │   ├── PatientRepository.java
│           │   ├── DoctorRepository.java
│           │   ├── AppointmentRepository.java
│           │   └── PatientRecordRepository.java
│           ├── service/               # Transactional Business Logic (@Service)
│           │   ├── AppointmentService.java
│           │   └── PatientService.java
│           ├── controller/            # REST API Endpoints (@RestController)
│           │   ├── AuthController.java
│           │   ├── AppointmentController.java
│           │   ├── PatientController.java
│           │   └── DoctorController.java
│           └── dto/                   # Data Transfer Objects
│               ├── LoginRequest.java
│               └── AuthResponse.java
│
├── src/                               # LAYER 1: React 19 Frontend
│   ├── types/                         # TypeScript interfaces (matching Java models)
│   ├── services/                      # API client, auth service, and SQL runner
│   ├── components/                    # Modular UI components
│   │   ├── auth/LoginModal.tsx        # Secure authentication with quick-fill buttons
│   │   ├── admin/AdminDashboard.tsx   # Comprehensive hospital metrics & queue management
│   │   ├── doctor/DoctorPortal.tsx    # Doctor consultation desk, vitals & EHR entry
│   │   ├── patient/PatientPortal.tsx  # Patient self-booking & health records
│   │   ├── sql/SqlConsole.tsx         # Interactive SQL Query runner & schema inspector
│   │   └── backend/SpringBootExplorer.tsx # Live REST trace & Spring Boot code viewer
│   ├── App.tsx                        # Main application container & state router
│   ├── main.tsx                       # React DOM entry point
│   └── index.css                      # Tailwind CSS v4 styling
│
├── package.json                       # Node.js dependencies
├── tsconfig.json                      # TypeScript configuration
└── README.md                          # Step-by-step project documentation
```

---

## 4. Step-by-Step Setup & Execution Guide

### **Step 1: Database Setup (Layer 3)**

1. Install and start **MySQL** (or PostgreSQL / Docker):
   ```bash
   mysql -u root -p
   ```
2. Create the database:
   ```sql
   CREATE DATABASE medikiosk_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE medikiosk_db;
   ```
3. Execute the schema and seed scripts:
   ```bash
   mysql -u root -p medikiosk_db < database/schema.sql
   mysql -u root -p medikiosk_db < database/data.sql
   ```
4. Verify table creation:
   ```sql
   SHOW TABLES;
   -- Should display: users, doctors, patients, appointments, patient_records
   ```

---

### **Step 2: Backend Setup (Layer 2 - Spring Boot)**

1. Ensure **Java 17+** and **Maven 3.8+** are installed:
   ```bash
   java -version
   mvn -version
   ```
2. Navigate to the `backend/` directory:
   ```bash
   cd backend
   ```
3. Update database credentials in `src/main/resources/application.properties` if needed:
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/medikiosk_db?useSSL=false&serverTimezone=UTC
   spring.datasource.username=root
   spring.datasource.password=root_password
   ```
4. Build and run the Spring Boot application:
   ```bash
   mvn clean spring-boot:run
   ```
   *The backend will start on **`http://localhost:8080`**.*

---

### **Step 3: Frontend Setup (Layer 1 - React)**

1. Ensure **Node.js 18+** is installed:
   ```bash
   node -v
   ```
2. In the project root directory, install dependencies:
   ```bash
   npm install
   ```
3. Start the Vite development server:
   ```bash
   npm run dev
   ```
4. Open your browser and navigate to:
   ```
   http://localhost:3000
   ```

---

## 5. REST API Specifications

### **Authentication**
- `POST /api/auth/login`: Authenticate user credentials and return role and session token.

### **Appointments**
- `GET /api/appointments`: Retrieve all scheduled appointments.
- `GET /api/appointments/today-queue`: Retrieve today's outpatient appointments sorted by token number.
- `POST /api/appointments`: Book an appointment (auto-generates appointment number & token).
- `PUT /api/appointments/{id}/status?status={status}`: Update status (`CONFIRMED`, `COMPLETED`, `CANCELLED`).
- `DELETE /api/appointments/{id}`: Cancel an appointment.

### **Patients & Records (EHR)**
- `GET /api/patients`: Search and list registered patients.
- `GET /api/patients/{id}`: Get patient demographic profile by ID.
- `POST /api/patients`: Register a new patient and issue Medical Record Number (MRN).
- `GET /api/patients/{id}/records`: Retrieve patient consultation history and vitals.
- `POST /api/patients/{id}/records`: Record clinical notes, vitals, and prescriptions.

### **Doctors**
- `GET /api/doctors`: List all doctors or filter by department (`?department=Cardiology`).
- `GET /api/doctors/{id}`: Get doctor consultation details and availability.

---

## 6. Key Viva & Academic Review Questions

1. **Why is the project divided into three layers?**  
   *Separation of Concerns (SoC). The React frontend handles user experience and input validation; the Spring Boot backend encapsulates business logic and security; and the SQL database enforces ACID transactions, relational foreign keys, and persistent storage.*

2. **How is the sequential OPD token allocated?**  
   *In `AppointmentService.java`, the method `getNextTokenNumberForDate(date)` queries `MAX(token_number) + 1` for the specified appointment date inside a `@Transactional` boundary, preventing token duplication.*

3. **What database normalization level is applied?**  
   *3rd Normal Form (3NF). Redundant patient data is not duplicated in appointments; only the foreign keys `patient_id` and `doctor_id` are stored. Medical records link directly to patients and physicians.*

4. **How does Role-Based Access Control (RBAC) work in MediKiosk?**  
   *Every user entity has a role (`ROLE_ADMIN`, `ROLE_DOCTOR`, `ROLE_PATIENT`). The frontend dynamically adjusts navigation and permissions, while the backend verifies authorization on protected REST endpoints.*
