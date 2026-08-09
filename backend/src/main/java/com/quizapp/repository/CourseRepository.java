package com.quizapp.repository;

import com.quizapp.entities.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface CourseRepository extends JpaRepository<Course, Long> {
    boolean existsByInstructorId(Long instructorId);

    // The instructor name now lives in the linked users table, so both levels are
    // loaded before the repository closes its database session.
    @Query("select c from Course c join fetch c.instructor i join fetch i.user " +
            "where i.id = :instructorId")
    List<Course> findByInstructorId(Long instructorId);

    @Query("select c from Course c join fetch c.instructor i join fetch i.user " +
            "order by c.courseName")
    List<Course> findAllWithInstructor();

    @Query("select c from Course c join fetch c.instructor i join fetch i.user " +
            "join c.enrollments e where e.student.id = :studentId")
    List<Course> findForStudent(Long studentId);
}
