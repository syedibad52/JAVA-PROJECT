package model;

public class Course {
    private int id;
    private String courseName;
    private String description;
    private int credits;
    private int capacity;
    private String instructor;
    private String schedule;

    public Course() {
    }

    public Course(int id, String courseName, String description,
            int credits, int capacity, String instructor, String schedule) {
        this.id = id;
        this.courseName = courseName;
        this.description = description;
        this.credits = credits;
        this.capacity = capacity;
        this.instructor = instructor;
        this.schedule = schedule;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCredits() {
        return credits;
    }

    public void setCredits(int credits) {
        this.credits = credits;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getInstructor() {
        return instructor;
    }

    public void setInstructor(String instructor) {
        this.instructor = instructor;
    }

    public String getSchedule() {
        return schedule;
    }

    public void setSchedule(String schedule) {
        this.schedule = schedule;
    }
}
