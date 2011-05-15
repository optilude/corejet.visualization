import os.path
import shutil
import tempfile
import datetime
import unittest2 as unittest

from corejet.core import Scenario, story, scenario, given, when, then

@story(id="CV-1", title="As a developer, I can generate a visualisation")
class ReportGeneration(unittest.TestCase):
    
    @scenario("Basic visualization")
    class Basic(Scenario):
    
        @given("A temporary directory")
        def tempDir(self):
            self.tmpdir = tempfile.mkdtemp()
        
        @given("A requirements catalogue containing test results")
        def create(self):
            from corejet.core.model import RequirementsCatalogue
            from corejet.core.model import Epic, Story, Scenario, Step
            
            self.catalogue = RequirementsCatalogue(project="Test project",
                extractTime=datetime.datetime(2011,1,2,12,1,0),
                testTime=datetime.datetime(2011,1,2,12,5,0))
            
            epic1 = Epic("E1", "First epic")
            self.catalogue.epics.append(epic1)
            
            epic2 = Epic("E2", "Second epic")
            self.catalogue.epics.append(epic2)
            
            story1 = Story("S1", "First story", points=3, status="open",
                priority="high", epic=epic1)
            epic1.stories.append(story1)
            
            story2 = Story("S2", "Second story", points=3, status="closed",
                resolution="fixed", priority="high", epic=epic1)
            epic1.stories.append(story2)
            
            scenario1 = Scenario("First scenario", story=story1,
                    givens=[Step("something", 'given')],
                    whens=[Step("something happens", 'when')],
                    thens=[Step("do something", 'then'), Step("and something else", 'then')],
                    status="pass",
                )
            story1.scenarios.append(scenario1)
            
            scenario2 = Scenario("Second scenario", story=story2,
                    givens=[Step("something", 'given')],
                    whens=[Step("something happens", 'when')],
                    thens=[Step("do something", 'then'), Step("and something else", 'then')],
                    status="mismatch",
                )
            story1.scenarios.append(scenario2)
        
        @when("The generateReportFromCatalogue() function is called")
        def serialize(self):
            from corejet.visualization import generateReportFromCatalogue
            generateReportFromCatalogue(self.catalogue, self.tmpdir)
        
        @then("The temporary directory contains a report")
        def checkOutput(self):
            self.assertTrue(os.path.exists(os.path.join(self.tmpdir, 'index.html')))
            self.assertTrue(os.path.exists(os.path.join(self.tmpdir, 'corejet-requirements.js')))
        
        @then("Clean up")
        def cleanUp(self):
            shutil.rmtree(self.tmpdir)
