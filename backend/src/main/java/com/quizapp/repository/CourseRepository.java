package com.quizapp.repository;

import com.quizapp.entities.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {
    @Query("select c from Course c join fetch c.instructor where c.instructor.id = :instructorId")
    List<Course> findByInstructorId(Long instructorId);

    @Query("select c from Course c join fetch c.instructor order by c.courseName")
    List<Course> findAllWithInstructor();

    @Query("select c from Course c join fetch c.instructor join c.enrollments e where e.student.id = :studentId")
    List<Course> findForStudent(Long studentId);
}
