package com.example.barstock_v1

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.viewpager.widget.ViewPager
import com.google.android.material.tabs.TabLayout

class MainActivity : AppCompatActivity() {

    private lateinit var viewPager : ViewPager
    private lateinit var tabLayout: TabLayout // Declare the variable


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        viewPager = findViewById(R.id.viewPager) // Initialize the variable
        tabLayout = findViewById(R.id.tabLayout) // Initialize the variable
        setUpTabs()
    }

    private fun setUpTabs() {
        val adapter = ViewPagerAdapter(supportFragmentManager)
        adapter.addFragment(AlcoholFragment(), "Alcohols")
        adapter.addFragment(CocktailsFragment(), "Cocktails")
        viewPager.adapter = adapter
        tabLayout.setupWithViewPager(viewPager)

        tabLayout.getTabAt(0)!!.setIcon(R.drawable.baseline_sports_bar_24)
        tabLayout.getTabAt(1)!!.setIcon(R.drawable.baseline_local_bar_24)

    }
}