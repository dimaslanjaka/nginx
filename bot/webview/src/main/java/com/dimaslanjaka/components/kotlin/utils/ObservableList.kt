package com.dimaslanjaka.components.kotlin.utils

import java.util.*

class ObservableList<T>(private val wrapped: MutableList<T>) : MutableList<T> by wrapped, Observable() {
    override fun add(element: T): Boolean {
        if (wrapped.add(element)) {
            setChanged()
            notifyObservers()
            return true
        }
        return false
    }
}