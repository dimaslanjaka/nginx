package com.dimaslanjaka.webview;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentStatePagerAdapter;

/**
 * Created by tutlane on 19-12-2017.
 */

public class TabsAdapter extends FragmentStatePagerAdapter {
    int mNumOfTabs;

    public TabsAdapter(FragmentManager fm, int NoofTabs) {
        super(fm);
        this.mNumOfTabs = NoofTabs;
    }

    @Override
    public int getCount() {
        return mNumOfTabs;
    }

    @Override
    public Fragment getItem(int position) {
        switch (position) {
            case 0:
                BrowserFragment home = new BrowserFragment();
                return home;
            case 1:
                BrowserFragment about = new BrowserFragment();
                return about;
            case 2:
                BrowserFragment contact = new BrowserFragment();
                return contact;
            default:
                return null;
        }
    }
}