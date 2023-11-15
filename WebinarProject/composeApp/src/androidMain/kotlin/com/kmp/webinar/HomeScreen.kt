package com.kmp.webinar

import cafe.adriel.voyager.core.screen.Screen
import androidx.compose.material.Surface
import androidx.compose.runtime.*
import country.Country
import location.getCountryCode
import cache.CountrySDK
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Text
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.ui.Alignment.Companion.CenterHorizontally
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.material.MaterialTheme

class HomeScreen() : Screen {
    @Composable
    override fun Content() {
        Surface {
            var listCountries: List<Country> by remember { mutableStateOf(mutableListOf()) }

            LaunchedEffect(Unit) {
                listCountries = CountrySDK().getCountries()
            }

            Column {
                LazyColumn() {
                    itemsIndexed(items = listCountries) { index, item ->
                        CountryCard(
                            modifier = Modifier,
                            country = item,
                            currentCountry = index == 0
                        )
                    }
                }
            }
        }
    }
}
