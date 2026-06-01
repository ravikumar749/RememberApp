subprojects {
    afterEvaluate {
        project.plugins.withId("com.android.library") {
            project.extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
    }
}