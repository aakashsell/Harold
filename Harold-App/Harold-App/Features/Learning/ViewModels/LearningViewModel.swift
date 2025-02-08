//
//  LearningViewModel.swift
//  Harold-App
//
//  Created by Juan Pablo Urista on 2/7/25.
//

import Foundation
import SwiftData

class LearningViewModel: ObservableObject {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupInitialCourses()
    }
    
    private func setupInitialCourses() {
        do {
            let courseDescriptor = FetchDescriptor<Course>()
            let existingCourses = try modelContext.fetch(courseDescriptor)
            
            if existingCourses.isEmpty {
                print("No courses found. Creating initial courses...")
                let initialCourses = createCourses()
                
                // Unlock the first course
                if let firstCourse = initialCourses.first {
                    firstCourse.isUnlocked = true
                    
                    // Unlock the first lesson of the first course
                    if let firstLesson = firstCourse.lessons.first {
                        firstLesson.isUnlocked = true
                        print("First lesson unlocked: \(firstLesson.title)")
                    }
                }
                
                initialCourses.forEach { modelContext.insert($0) }
                try modelContext.save()
                print("Initial courses created and saved.")
            } else {
                print("Courses already exist in the database.")
                // Debug: Print the unlocked status of the first course and its lessons
                if let firstCourse = existingCourses.first {
                    print("First course unlocked: \(firstCourse.isUnlocked)")
                    if let firstLesson = firstCourse.lessons.first {
                        print("First lesson unlocked: \(firstLesson.isUnlocked)")
                        
                        // Ensure the first lesson is unlocked if the first course is unlocked
                        if firstCourse.isUnlocked && !firstLesson.isUnlocked {
                            firstLesson.isUnlocked = true
                            print("Manually unlocked first lesson: \(firstLesson.title)")
                            try modelContext.save()
                        }
                    }
                }
            }
        } catch {
            print("Error setting up initial courses: \(error)")
        }
    }
    
    func completeLesson(_ lesson: Lesson, in course: Course) throws {
        guard !lesson.isCompleted else { return }
        
        // Mark the current lesson as completed
        lesson.isCompleted = true
        lesson.completedAt = Date()
        print("Completed lesson: \(lesson.title)")
        
        // Update course progress
        let completedLessons = course.lessons.filter { $0.isCompleted }
        course.progress = Double(completedLessons.count) / Double(course.lessons.count)
        print("Course progress: \(course.progress * 100)%")
        
        // Check if course is completed
        if course.progress >= 1.0 {
            course.isCompleted = true
            print("Course completed: \(course.title)")
            
            // Unlock the next course
            unlockNextCourse(after: course)
        }
        
        // Unlock the next lesson if it exists
        if let currentIndex = course.lessons.firstIndex(where: { $0.id == lesson.id }),
           currentIndex + 1 < course.lessons.count {
            let nextLesson = course.lessons[currentIndex + 1]
            nextLesson.isUnlocked = true
            print("Unlocked next lesson: \(nextLesson.title)")
        } else {
            print("No next lesson to unlock.")
        }
        
        // Save changes to the ModelContext
        try modelContext.save()
        print("Changes saved to ModelContext.")
    }
    
    private func unlockNextCourse(after currentCourse: Course) {
        do {
            let courseDescriptor = FetchDescriptor<Course>()
            var courses = try modelContext.fetch(courseDescriptor)
            
            // Sort courses to ensure consistent order
            courses.sort { $0.title < $1.title } // Sort by title or another property
            print("Fetched courses: \(courses.map { $0.title })")
            
            if let currentIndex = courses.firstIndex(where: { $0.id == currentCourse.id }),
               currentIndex + 1 < courses.count {
                let nextCourse = courses[currentIndex + 1]
                nextCourse.isUnlocked = true
                print("Unlocked next course: \(nextCourse.title)")
                
                // Unlock the first lesson of the next course
                if let firstLesson = nextCourse.lessons.first {
                    firstLesson.isUnlocked = true
                    print("Unlocked first lesson of next course: \(firstLesson.title)")
                } else {
                    print("Next course has no lessons.")
                }
            } else {
                print("No next course to unlock.")
            }
            
            // Save changes to the ModelContext
            try modelContext.save()
            print("Changes saved to ModelContext.")
        } catch {
            print("Error unlocking next course: \(error)")
        }
    }
    
    private func createCourses() -> [Course] {
        [
            // Course 1: Plant Basics
            Course(
                title: "Plant Basics",
                desc: "Learn the basics of plant care",
                lessons: [
                    Lesson(
                        title: "Introduction to Plants",
                        desc: "Understand the basics of plant biology",
                        content: [
                            .text("Plants are essential for life on Earth."),
                            .image(URL(string: "https://www.e-education.psu.edu/earth103/sites/www.e-education.psu.edu.earth103/files/module05/Photsynthesis_Respiration.png")!),
                            .quiz([
                                Lesson.QuizQuestion(
                                    question: "What is the primary function of leaves?",
                                    options: ["Absorb water", "Photosynthesis", "Support the plant", "Attract insects"],
                                    correctAnswer: 1
                                )
                            ])
                        ]
                    ),
                    Lesson(
                        title: "Watering Plants",
                        desc: "Learn how to properly water your plants",
                        content: [
                            .text("Watering is crucial for plant health."),
                            .image(URL(string: "https://plantlet.org/wp-content/uploads/2020/04/Transpiration.png")!),
                            .quiz([
                                Lesson.QuizQuestion(
                                    question: "How often should you water most plants?",
                                    options: ["Daily", "Weekly", "Monthly", "When the soil is dry"],
                                    correctAnswer: 3
                                )
                            ])
                        ]
                    )
                ],
                courseOrder: 1
            ),
            // Course 2: Advanced Plant Care
            Course(
                title: "Advanced Plant Care",
                desc: "Master advanced techniques for plant care",
                lessons: [
                    Lesson(
                        title: "Pruning Techniques",
                        desc: "Learn how to prune plants for optimal growth",
                        content: [
                            .text("Pruning helps plants grow healthier and stronger."),
                            .image(URL(string: "https://anokaswcd.org/images/easyblog_articles/292/b2ap3_large_pruning-2.jpg")!),
                            .quiz([
                                Lesson.QuizQuestion(
                                    question: "What is the main purpose of pruning?",
                                    options: ["To make plants look pretty", "To remove dead or diseased branches", "To reduce water usage", "To attract pollinators"],
                                    correctAnswer: 1
                                )
                            ])
                        ]
                    )
                ],
                courseOrder: 2
            ),
            // Course 3: Plant Nutrition
            Course(
                title: "Plant Nutrition",
                desc: "Understand the role of nutrients in plant growth",
                lessons: [
                    Lesson(
                        title: "Essential Nutrients",
                        desc: "Learn about the key nutrients plants need",
                        content: [
                            .text("Plants require a balance of macronutrients and micronutrients."),
                            .image(URL(string: "https://media.istockphoto.com/id/921983682/vector/diagram-of-nutrients-in-organic-fertilizers.jpg?s=612x612&w=0&k=20&c=grL-2JBU4XiVBSDu5v4WqKwduJIQrif1bCnWZGHcp9s=")!),
                            .quiz([
                                Lesson.QuizQuestion(
                                    question: "Which nutrient is essential for leaf growth?",
                                    options: ["Phosphorus", "Potassium", "Nitrogen", "Calcium"],
                                    correctAnswer: 2
                                )
                            ])
                        ]
                    )
                ],
                courseOrder: 3
            ),
            // Course 4: Troubleshooting Plant Problems
            Course(
                title: "Troubleshooting Plant Problems",
                desc: "Identify and solve common plant issues",
                lessons: [
                    Lesson(
                        title: "Common Pests",
                        desc: "Learn how to identify and treat plant pests",
                        content: [
                            .text("Pests can damage plants and reduce their health."),
                            .image(URL(string: "https://o.quizlet.com/UT4BhbvaJHcji1AnzoW9kg.jpg")!),
                            .quiz([
                                Lesson.QuizQuestion(
                                    question: "What is a common treatment for aphids?",
                                    options: ["Neem oil", "Fertilizer", "More water", "Direct sunlight"],
                                    correctAnswer: 0
                                )
                            ])
                        ]
                    )
                ],
                courseOrder: 4
            )
        ]
    }
}
