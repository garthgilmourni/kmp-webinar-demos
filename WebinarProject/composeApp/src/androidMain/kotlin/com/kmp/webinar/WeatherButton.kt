package com.kmp.webinar

import androidx.compose.runtime.*
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.material.Button
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.material.Text
import cafe.adriel.voyager.navigator.LocalNavigator
import cafe.adriel.voyager.navigator.currentOrThrow
import country.CapitalInfo

@Composable
fun WeatherButton(modifier: Modifier = Modifier, capitals: List<String>, capitalInfo: CapitalInfo) {
    val navigator = LocalNavigator.currentOrThrow
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.Bottom
    ) {
        Column {
            capitals.forEach {
                Button(onClick = {
                    navigator.push(
                        WeatherScreen(
                            cityName = it,
                            lat = capitalInfo.latlng[0].toDouble(),
                            long = capitalInfo.latlng[1].toDouble()
                        )
                    )
                }) {
                    Text(text = "$it weather")
                }
            }
        }
    }
}