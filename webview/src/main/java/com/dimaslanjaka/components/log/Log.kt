package com.dimaslanjaka.components.log

import android.text.TextUtils
import android.util.Log

/**
 * Improved android.util.Log.
 *
 *
 * Logs class and method automatically:
 * [MyApplication onCreate():34] Hello, world!
 * [MyClass myMethod():42] my log msg
 *
 *
 * Install:
 * $ find -name "*.java" -type f -exec sed -i 's/import android.util.Log/import me.shkschneider.skeleton.helper.Log/g' {} \;
 *
 *
 * Better to use with adb -s com.example.myapp
 */
open class Log protected constructor() {
    companion object {
        private const val VERBOSE = Log.VERBOSE
        private const val DEBUG = Log.DEBUG
        private const val INFO = Log.INFO
        private const val WARN = Log.WARN
        private const val ERROR = Log.ERROR
        private const val WTF = Log.ASSERT

        // Used to identify the source of a log message.
        // It usually identifies the class or activity where the log call occurs.
        protected var TAG = "LogHelper"

        fun setTag(clazz: Class<Any>): Companion {
            TAG = clazz.name
            return Log
        }

        fun setTag(logName: String): Companion {
            TAG = logName
            return Log
        }

        // Here I prefer to use the application's packageName
        protected fun log(level: Int, msg: String?, throwable: Throwable?) {
            val elements = Throwable().stackTrace
            var callerClassName = "?"
            var callerMethodName = "?"
            var callerLineNumber = "?"
            if (elements.size >= 4) {
                callerClassName = elements[3].className
                callerClassName = callerClassName.substring(callerClassName.lastIndexOf('.') + 1)
                if (callerClassName.indexOf("$") > 0) {
                    callerClassName = callerClassName.substring(0, callerClassName.indexOf("$"))
                }
                callerMethodName = elements[3].methodName
                callerMethodName = callerMethodName.substring(callerMethodName.lastIndexOf('_') + 1)
                if (callerMethodName == "<init>") {
                    callerMethodName = callerClassName
                }
                callerLineNumber = elements[3].lineNumber.toString()
            }
            val stack = "[" + callerClassName + "." + callerMethodName + "():" + callerLineNumber + "]" + if (TextUtils.isEmpty(msg)) "" else " "
            when (level) {
                VERBOSE -> Log.v(TAG, stack + msg, throwable)
                DEBUG -> Log.d(TAG, stack + msg, throwable)
                INFO -> Log.i(TAG, stack + msg, throwable)
                WARN -> Log.w(TAG, stack + msg, throwable)
                ERROR -> Log.e(TAG, stack + msg, throwable)
                WTF -> Log.wtf(TAG, stack + msg, throwable)
                else -> {
                    Log.e("E-$TAG", stack + msg, throwable)
                }
            }
        }

        fun d(msg: String) {
            log(DEBUG, msg, null)
        }

        fun d(msg: String?, throwable: Throwable) {
            log(DEBUG, msg, throwable)
        }

        fun d(msg: Any) {
            d(msg.toString())
        }

        @JvmStatic
        fun debug(msg: String) {
            d(msg)
        }

        @JvmStatic
        fun debug(msg: String?, throwable: Throwable) {
            d(msg, throwable)
        }

        @JvmStatic
        fun debug(msg: Any) {
            d(msg)
        }

        @JvmStatic
        fun d(vararg msg: Any?) {
            d(msg.contentToString())
        }

        @JvmStatic
        fun v(msg: String) {
            log(VERBOSE, msg, null)
        }

        @JvmStatic
        fun v(msg: String?, throwable: Throwable) {
            log(VERBOSE, msg, throwable)
        }

        @JvmStatic
        fun i(msg: String) {
            log(INFO, msg, null)
        }

        @JvmStatic
        fun i(msg: String?, throwable: Throwable) {
            log(INFO, msg, throwable)
        }

        @JvmStatic
        fun w(msg: String) {
            log(WARN, msg, null)
        }

        @JvmStatic
        fun w(msg: String?, throwable: Throwable) {
            log(WARN, msg, throwable)
        }

        @JvmStatic
        fun e(msg: String) {
            log(ERROR, msg, null)
        }

        @JvmStatic
        fun e(msg: String?, throwable: Throwable) {
            log(ERROR, msg, throwable)
        }

        @JvmStatic
        fun wtf(msg: String) {
            log(WTF, msg, null)
        }

        @JvmStatic
        fun wtf(msg: String?, throwable: Throwable) {
            log(WTF, msg, throwable)
        }

        @Deprecated("")
        fun wtf(throwable: Throwable) {
            log(WTF, null, throwable)
        }

        @JvmStatic
        fun e(message: Any) {
            e(message.toString())
        }

        @JvmStatic
        fun e(vararg message: Any?) {
            e(message.contentToString())
        }

        @JvmStatic
        fun w(vararg msg: Any?) {
            w(msg.contentToString())
        }

        @JvmStatic
        fun i(msg: Any) {
            i(msg.toString())
        }

        @JvmStatic
        fun i(vararg msg: Any?) {
            i(msg.contentToString())
        }

        @JvmStatic
        fun v(vararg msg: Any?) {
            v(msg.contentToString())
        }

        private fun filter(e: StackTraceElement): Boolean {
            val fullname = e.className + "." + e.methodName
            return (fullname.trim { it <= ' ' }.endsWith("Log.out")
                    || fullname.trim { it <= ' ' }.endsWith("Log.v")
                    || fullname.trim { it <= ' ' }.endsWith("Log.i")
                    || fullname.trim { it <= ' ' }.endsWith("Log.e")
                    || fullname.trim { it <= ' ' }.endsWith("Log.d")
                    || fullname.trim { it <= ' ' }.endsWith("fixTag")
                    || fullname.trim { it <= ' ' }.contains("UtilsKt.log")
                    || fullname.trim { it <= ' ' }.contains("service.Log"))
        }

        @JvmStatic
        fun out(msg: String?) {
            fixTag()
            i(msg)
        }

        private fun fixTag() {
            val stacktrace = Thread.currentThread().stackTrace
            var e = stacktrace[2] //maybe this number needs to be corrected
            if (filter(e)) {
                e = stacktrace[3]
                if (filter(e)) {
                    e = stacktrace[4]
                    if (filter(e)) {
                        e = stacktrace[5]
                        if (filter(e)) {
                            e = stacktrace[6]
                        }
                    }
                }
            }
            TAG = e.className + "." + e.methodName
            if (TAG == "<init>") {
                TAG = e.className
            }
            TAG += "(" + e.lineNumber + ")"
            //TAG = TAG.replace(BuildConfig.APPLICATION_ID, "")
        }

        @JvmStatic
        fun w(o: Any) {
            w(o.toString())
        }

        fun out(o: Any) {
            i(o.toString())
        }

        fun out(vararg o: Any?) {
            i(o.contentToString())
        }

        init {
            fixTag()
        }
    }

    init {
        fixTag()
    }
}