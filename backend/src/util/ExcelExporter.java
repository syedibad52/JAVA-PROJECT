package util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.File;
import java.io.FileOutputStream;
import java.sql.*;
import java.text.SimpleDateFormat;

/**
 * Utility class that auto-exports student registrations and course enrollments
 * to Excel (.xlsx) files on the Desktop. Files are rewritten with the latest
 * data from MySQL every time an action occurs, so they always reflect real-time state.
 */
public class ExcelExporter {

    private static final String EXPORT_DIR;
    private static final String REGISTRATIONS_FILE;
    private static final String ENROLLMENTS_FILE;

    static {
        String dirPath;
        String os = System.getProperty("os.name").toLowerCase();
        if (os.contains("win")) {
            String home = System.getProperty("user.home");
            File oneDriveDesktop = new File(home + File.separator + "OneDrive" + File.separator + "Desktop");
            if (oneDriveDesktop.exists() && oneDriveDesktop.isDirectory()) {
                dirPath = oneDriveDesktop.getAbsolutePath();
            } else {
                File normalDesktop = new File(home + File.separator + "Desktop");
                if (normalDesktop.exists() && normalDesktop.isDirectory()) {
                    dirPath = normalDesktop.getAbsolutePath();
                } else {
                    dirPath = home + File.separator + "CourseRegistrationSystem_Exports";
                }
            }
        } else {
            File dataExports = new File("/data/exports");
            if (dataExports.exists() || dataExports.mkdirs()) {
                dirPath = "/data/exports";
            } else {
                dirPath = System.getProperty("user.home") + File.separator + "exports";
            }
        }

        File exportDir = new File(dirPath);
        if (!exportDir.exists()) {
            exportDir.mkdirs();
        }
        EXPORT_DIR = exportDir.getAbsolutePath();
        REGISTRATIONS_FILE = EXPORT_DIR + File.separator + "student_registrations.xlsx";
        ENROLLMENTS_FILE = EXPORT_DIR + File.separator + "course_enrollments.xlsx";
        System.out.println("[ExcelExporter] Active export directory set to: " + EXPORT_DIR);
    }

    private static final SimpleDateFormat DATE_FMT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    /**
     * Exports all student registrations from the database to student_registrations.xlsx on the Desktop.
     * Called automatically after every new student registration.
     */
    public static void exportStudentRegistrations() {
        String sql = "SELECT id, name, email, created_at FROM students ORDER BY created_at DESC";

        try (Connection con = DBUtil.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql);
             Workbook workbook = new XSSFWorkbook()) {

            Sheet sheet = workbook.createSheet("Student Registrations");

            // ---- Create Header Style ----
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setFontHeightInPoints((short) 12);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            // ---- Create Data Cell Style ----
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);

            // ---- Write Header Row ----
            String[] headers = {"S.No", "Student ID", "Name", "Email", "Registration Time"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // ---- Write Data Rows ----
            int rowIndex = 1;
            while (rs.next()) {
                Row row = sheet.createRow(rowIndex);

                Cell c0 = row.createCell(0);
                c0.setCellValue(rowIndex);
                c0.setCellStyle(dataStyle);

                Cell c1 = row.createCell(1);
                c1.setCellValue(rs.getInt("id"));
                c1.setCellStyle(dataStyle);

                Cell c2 = row.createCell(2);
                c2.setCellValue(rs.getString("name"));
                c2.setCellStyle(dataStyle);

                Cell c3 = row.createCell(3);
                c3.setCellValue(rs.getString("email"));
                c3.setCellStyle(dataStyle);

                Cell c4 = row.createCell(4);
                Timestamp ts = rs.getTimestamp("created_at");
                c4.setCellValue(ts != null ? DATE_FMT.format(ts) : "N/A");
                c4.setCellStyle(dataStyle);

                rowIndex++;
            }

            // Auto-size columns for readability
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Write to file on Desktop
            try (FileOutputStream fos = new FileOutputStream(REGISTRATIONS_FILE)) {
                workbook.write(fos);
            }
            System.out.println("[ExcelExporter] Student registrations exported to: " + REGISTRATIONS_FILE);

        } catch (Exception e) {
            System.err.println("[ExcelExporter] Failed to export student registrations: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Exports all course enrollments from the database to course_enrollments.xlsx on the Desktop.
     * Called automatically after every enroll or drop action.
     */
    public static void exportCourseEnrollments() {
        String sql = "SELECT e.id, s.name AS student_name, s.email AS student_email, " +
                     "c.course_name, c.instructor, e.enrolled_at " +
                     "FROM enrollments e " +
                     "JOIN students s ON e.student_id = s.id " +
                     "JOIN courses c ON e.course_id = c.id " +
                     "ORDER BY e.enrolled_at DESC";

        try (Connection con = DBUtil.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql);
             Workbook workbook = new XSSFWorkbook()) {

            Sheet sheet = workbook.createSheet("Course Enrollments");

            // ---- Create Header Style ----
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setFontHeightInPoints((short) 12);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            // ---- Create Data Cell Style ----
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);

            // ---- Write Header Row ----
            String[] headers = {"S.No", "Enrollment ID", "Student Name", "Student Email", "Course Name", "Instructor", "Enrollment Time"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // ---- Write Data Rows ----
            int rowIndex = 1;
            while (rs.next()) {
                Row row = sheet.createRow(rowIndex);

                Cell c0 = row.createCell(0);
                c0.setCellValue(rowIndex);
                c0.setCellStyle(dataStyle);

                Cell c1 = row.createCell(1);
                c1.setCellValue(rs.getInt("id"));
                c1.setCellStyle(dataStyle);

                Cell c2 = row.createCell(2);
                c2.setCellValue(rs.getString("student_name"));
                c2.setCellStyle(dataStyle);

                Cell c3 = row.createCell(3);
                c3.setCellValue(rs.getString("student_email"));
                c3.setCellStyle(dataStyle);

                Cell c4 = row.createCell(4);
                c4.setCellValue(rs.getString("course_name"));
                c4.setCellStyle(dataStyle);

                Cell c5 = row.createCell(5);
                c5.setCellValue(rs.getString("instructor"));
                c5.setCellStyle(dataStyle);

                Cell c6 = row.createCell(6);
                Timestamp ts = rs.getTimestamp("enrolled_at");
                c6.setCellValue(ts != null ? DATE_FMT.format(ts) : "N/A");
                c6.setCellStyle(dataStyle);

                rowIndex++;
            }

            // Auto-size columns for readability
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Write to file on Desktop
            try (FileOutputStream fos = new FileOutputStream(ENROLLMENTS_FILE)) {
                workbook.write(fos);
            }
            System.out.println("[ExcelExporter] Course enrollments exported to: " + ENROLLMENTS_FILE);

        } catch (Exception e) {
            System.err.println("[ExcelExporter] Failed to export course enrollments: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
