<?php


/**
 * Class ImageMapHelper
 */
class ImageMapHelper
{

    /**
     * @param $imageMapCoordinates
     * @param int $xOffset
     * @param int $yOffset
     * @return string
     */
    public static function calculateOffset($imageMapCoordinates, $xOffset = 0, $yOffset = 0)
    {
        $imageMapCoordinatesOffset = '';
        $coordinates = explode(',', $imageMapCoordinates);

        for ($i = 0; $i < count($coordinates); $i++) {

            if ($i % 2 == 0) {
                $imageMapCoordinatesOffset .= $coordinates[$i] + $xOffset . ',';
            } else {
                $imageMapCoordinatesOffset .= $coordinates[$i] + $yOffset . ',';
            }
        }

        $imageMapCoordinatesOffset = rtrim($imageMapCoordinatesOffset, ',');


        return $imageMapCoordinatesOffset;
    }
}