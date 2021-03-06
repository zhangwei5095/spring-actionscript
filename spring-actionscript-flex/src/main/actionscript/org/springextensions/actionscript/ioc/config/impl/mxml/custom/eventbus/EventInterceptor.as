/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.eventbus {
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistryAware;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration.EventInterceptorCustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventInterceptor extends AbstractEventBusComponent {

		/**
		 * Creates a new <code>EventInterceptor</code> instance.
		 */
		public function EventInterceptor() {
			super();
		}

		public override function execute(applicationContext:IApplicationContext, objectDefinitions:Object, defaultDefinition:IBaseObjectDefinition=null, parentDefinition:IObjectDefinition=null, parentId:String=null):void {
			if (applicationContext is IEventBusUserRegistryAware) {
				eventBusUserRegistry = (applicationContext as IEventBusUserRegistryAware).eventBusUserRegistry;
			}
			var customConfiguration:Vector.<Object> = ContextUtils.getCustomConfigurationForObjectName(instance, applicationContext.objectDefinitionRegistry);
			for each (var field:Object in childContent) {
				if (field is InterceptionConfiguration) {
					var ic:InterceptionConfiguration = field as InterceptionConfiguration;
					var topics:Vector.<String> = ContextUtils.commaSeparatedPropertyValueToStringVector(ic.topics);
					var topicProperties:Vector.<String> = ContextUtils.commaSeparatedPropertyValueToStringVector(ic.topicProperties);
					var configurator:EventInterceptorCustomConfigurator = new EventInterceptorCustomConfigurator(eventBusUserRegistry, ic.eventName, ic.eventClass, topics, topicProperties);
					customConfiguration[customConfiguration.length] = configurator;
				}
			}
			applicationContext.objectDefinitionRegistry.registerCustomConfiguration(instance, customConfiguration);
		}

	}
}
