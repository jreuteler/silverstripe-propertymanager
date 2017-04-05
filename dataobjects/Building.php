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
        $fields = FieldList::create(TabSet::create('Root'));

        $fields->addFieldToTab('Root.Main', TextField::create('Title'));
        $fields->addFieldToTab('Root.Main', TextareaField::create('Text'));
        $conf = GridFieldConfig_RelationEditor::create();
        $fields->addFieldToTab('Root.Main', new GridField('Floors', 'Floors', $this->Floors(), $conf));

        $conf = GridFieldConfig_RelationEditor::create(10);
        $conf->addComponent(new GridFieldSortableRows('SortOrder'));
        $fields->addFieldToTab('Root.Main', new GridField('Floors', 'Floors', $this->Floors(), $conf));

        // Image / Offsets
        $fields->addFieldToTab('Root.Image/Offsets', UploadField::create('RoofImage')->setAllowedExtensions('png', 'jpg', 'jpeg'));
        $fields->addFieldToTab('Root.Image/Offsets', NumericField::create('BuildingOffsetX'));
        $fields->addFieldToTab('Root.Image/Offsets', NumericField::create('BuildingOffsetY'));
        $fields->addFieldToTab('Root.Image/Offsets', NumericField::create('AnimationOffsetX'));
        $fields->addFieldToTab('Root.Image/Offsets', NumericField::create('AnimationOffsetY'));
        $fields->addFieldToTab('Root.Image/Offsets', NumericField::create('RoofOffsetX'));
        $fields->addFieldToTab('Root.Image/Offsets', NumericField::create('RoofOffsetY'));
        $fields->addFieldToTab('Root.Image/Offsets', NumericField::create('RoofAnimationOffsetX'));
        $fields->addFieldToTab('Root.Image/Offsets', NumericField::create('RoofAnimationOffsetY'));

        return $fields;
    }

    public function LocationTitle()
    {
        if ($this->Location())
            return $this->Location()->Title;

        return '';
    }


}
