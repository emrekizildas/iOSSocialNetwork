//
//  ViewController.swift
//  Pager
//
//  Created by Lucas Oceano on 12/03/2015.
//  Copyright (c) 2015 Cheesecake. All rights reserved.
//

import UIKit

class ViewController: PagerController, PagerDataSource {

	var titles: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self

		// Instantiating Storyboard ViewControllers
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller1 = storyboard.instantiateViewController(withIdentifier: "anaView")
		let controller2 = storyboard.instantiateViewController(withIdentifier: "labelView")

		// Setting up the PagerController with Name of the Tabs and their respective ViewControllers
		self.setupPager(
			tabNames: ["Blue", "Orange"],
			tabControllers: [controller1, controller2])

		customizeTab()

	}

	// Customising the Tab's View
	func customizeTab() {
		indicatorColor = UIColor.white
	//	tabsViewBackgroundColor = UIColor(rgb: 0x00AA00)
		contentViewBackgroundColor = UIColor.gray.withAlphaComponent(0.32)

		startFromSecondTab = false
		centerCurrentTab = true
		tabLocation = PagerTabLocation.top
		tabHeight = 49
		tabOffset = 36
		tabWidth = 96.0
		fixFormerTabsPositions = false
		fixLaterTabsPosition = false
        animation = PagerAnimation.during
        selectedTabTextColor = .blue
        tabsTextFont = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        // tabTopOffset = 10.0
        // tabsTextColor = .purpleColor()

	}




}
