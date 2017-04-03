<?php

class InteractivePropertyPage extends Page
{
    public static $db = array();

    private static $has_one = array(
        'Location' => 'Location'
    );

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();

        $location = DropdownField::create('LocationID')
            ->setSource(Location::get()->map('ID', 'Title'))
            ->setDescription('Properties ')
            ->setEmptyString('Please select the location');


        $fields->addFieldToTab('Root.Main', $location);

        return $fields;
    }


}

class InteractivePropertyPage_Controller extends Page_Controller
{

    public function init()
    {

        parent::init();
    }


    public function index(SS_HTTPRequest $request)
    {
        Requirements::javascript(FRAMEWORK_DIR . '/thirdparty/jquery/jquery.js');
        Requirements::javascript(FRAMEWORK_DIR . '/thirdparty/jquery-entwine/dist/jquery.entwine-dist.js');
        Requirements::javascript(PROPERTYMANAGER_DIR . '/vendor/tooltipster/tooltipster.bundle.min.js');
        Requirements::css(PROPERTYMANAGER_DIR . '/vendor/tooltipster/tooltipster.bundle.min.css');
        Requirements::css(PROPERTYMANAGER_DIR . "/css/propertymanager.css");

        $buildingFloors = array();
        $dynamicCSS = '';

        foreach ($this->Location()->Buildings() as $building) {

            $buildingID = $building->ID;

            // writing css based on configuration
            $dynamicCSS .= '.building-' . $buildingID . '.building-overlay { left: ' . $building->BuildingOffsetX . 'px; top: ' . $building->BuildingOffsetY . ' } ';
            $dynamicCSS .= '.building-' . $buildingID . ' .floor-overlay.offset{
                left: ' . $building->AnimationOffsetX . 'px;  top: ' . $building->AnimationOffsetY . 'px; } ';
            $dynamicCSS .= '.roof-' . $buildingID . '.building-overlay { left: ' . $building->RoofOffsetX . 'px; top: ' . $building->RoofOffsetY . ' } ';
            $dynamicCSS .= '.building-' . $buildingID . '.offset .roof-overlay {
                left: ' . $building->RoofAnimationOffsetX . 'px !important;  top: ' . $building->RoofAnimationOffsetY . 'px !important; } ';

            foreach ($building->Floors() as $floor) {
                @$buildingFloors[$buildingID][] = array($floor->ID);
            }

        }


        $data = array(
            'PROPERTYMANAGER_DIR' => PROPERTYMANAGER_DIR,
            'LocationBackground' => $this->Location()->BackgroundImage(),
            'LocationBackgroundURL' => $this->Location()->BackgroundImage()->URL,
            'LocationBackgroundWidth' => $this->Location()->BackgroundImage()->getWidth(),
            'LocationBackgroundHeight' => $this->Location()->BackgroundImage()->getHeight(),

            'DynamicCSS' => $dynamicCSS,
            'BuildingFloorsJSON' => json_encode($buildingFloors),

            'BuildingsData' => $this->Location()->Buildings()

        );

        return $this->customise($data)->renderWith(array('InteractivePropertyPage', 'Page'));

    }


}