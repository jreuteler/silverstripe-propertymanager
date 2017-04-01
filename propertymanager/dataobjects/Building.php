<?php

class Building extends DataObject
{

    public static $db = array(
        'Title' => 'Varchar',
        'Text' => 'Text',
        'BuildingOffsetX' => 'Int',
        'BuildingOffsetY' => 'Int',
        'AnimationOffsetX' => 'Int',
        'AnimationOffsetY' => 'Int',

        'RoofOffsetX' => 'Int',
        'RoofOffsetY' => 'Int',
        'RoofAnimationOffsetX' => 'Int',
        'RoofAnimationOffsetY' => 'Int',
    );

    public static $has_one = array(
        'Location' => 'Location',
        'RoofImage' => 'Image',
    );

    public static $has_many = array(
        'Floors' => 'Floor',
    );

    public static $belongs_to = array(
        'Location' => 'Location',
    );

    private static $summary_fields = array(
        'Title',
        'LocationTitle'
    );

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();


        $conf=GridFieldConfig_RelationEditor::create(10);
        $conf->addComponent(new GridFieldSortableRows('SortOrder'));

        $fields->removeByName('Floors');

        $fields->addFieldToTab('Root.Main', new GridField('Floors', 'Floors', $this->Floors(), $conf));

        return $fields;
    }

    public function LocationTitle()
    {
        if ($this->Location())
            return $this->Location()->Title;

        return '';
    }


}
