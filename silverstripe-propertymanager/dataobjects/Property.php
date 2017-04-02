<?php

class Property extends DataObject
{

    public static $db = array(
        'Title' => 'Varchar',
        'Type' => 'Enum("Residential,Commercial","Commercial")',
        'Description' => 'Text',
    );

    public static $has_one = array(
        'Floor' => 'Floor',
        'OverviewImage' => 'Image',
    );


    private static $summary_fields = array(
        'Type', 'Title'
    );

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        return $fields;
    }

   





    public function FloorTitle()
    {
        if($this->Floor() ) {
            return $this->Floor()->Title;
        }

        return '';
    }

    public function FloorID()
    {
        if($this->Floor() ) {
            return $this->Floor()->ID;
        }

        return 0;
    }
    public function BuildingID()
    {
        if($this->Floor() != null && $this->Floor()->Building() != null ) {
            return $this->Floor()->Building()->ID;
        }

        return 0;
    }

    public function OverviewImageMapCoordinates()
    {
        if($this->OverviewImage()) {

            $offsetX = 0;
            $offsetY = 0;

            if( $this->Floor()->Building()!= null ) {
                $offsetX = $this->Floor()->Building()->BuildingOffsetX;
                $offsetY = $this->Floor()->Building()->BuildingOffsetY;
            }

            return  ImageMapHelper::calculateOffset($this->OverviewImage()->ImageMapCoordinates, $offsetX, $offsetY);

        }

        return '';
    }

}
