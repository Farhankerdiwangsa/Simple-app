package com.example.simpleapp

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    private var count = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val counterText = findViewById<TextView>(R.id.counterText)
        val addButton = findViewById<Button>(R.id.addButton)
        val resetButton = findViewById<Button>(R.id.resetButton)

        count = savedInstanceState?.getInt("count") ?: 0
        counterText.text = count.toString()

        addButton.setOnClickListener {
            count++
            counterText.text = count.toString()
        }
        resetButton.setOnClickListener {
            count = 0
            counterText.text = "0"
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putInt("count", count)
    }
}
